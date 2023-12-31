import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "month", "week", "slug", "timezone", "startsAt" ]
  static values = { recurrenceUrl: String, occurrenceUrl: String, type: String }

  monthTargetConnected(element) {
    this.setMonthValues(this.startsAtTarget.valueAsDate)
  }

  weekTargetConnected(element) {
    if (this.typeValue !== "edit")
      this.setWeekValues(this.startsAtTarget.valueAsDate)
  }

  timezoneTargetConnected(element) {
    element.value = Intl.DateTimeFormat().resolvedOptions().timeZone.split('/').reverse()[0]
  }

  date(event) {
    this.setWeekValues(event.target.valueAsDate);
    this.setMonthValues(event.target.valueAsDate);
  }

  setWeekValues(date) {
    this.weekTargets.forEach( week => {
      const elements = week.querySelectorAll('input');
      elements.forEach( el => {
        if (date)
          el.checked = el.value == date.getDay();
      });
    });
  }

  setMonthValues(date) {
    if (date === null)
      return;
    this.monthTargets.forEach( month => { 
      month.querySelector('option[value="nth_of_month"]').textContent = `${this.nth(date.getDate())} day of the month`;
      month.querySelector('option[value="nth_weekday_of_month"]').textContent = `${this.nthDayOfWeek(date)} ${this.weekday(date)} of the month`;
      month.querySelector('option[value="nth_last_weekday_of_month"]').textContent = `${this.nthLastDayOfWeek(date)} to last ${this.weekday(date)} of the month`;
    });
  }

  weekday(date) {
    switch(date.getDay()) {
      case 0:
        return 'Sunday'
      case 1:
        return 'Monday';
      case 2: 
        return 'Tuesday';
      case 3:
        return 'Wednesday'
      case 4:
        return 'Thursday';
      case 5: 
        return 'Friday';
      case 6:
        return 'Saturday';
    }
  }

  nth(value) {
    // Keep in mind we don't go over 100 here, otherwise this would be incorrect
    switch(parseInt(value.toString().split('').reverse()[0])) {
      case 1:
        if (value != 11)
          return `${value}st`
        break;
      case 2:
        if (value != 12)
          return `${value}nd`
        break;
      case 3:
        if (value != 13)
          return `${value}rd`
    }
    return `${value}th`
  }

  nthDayOfWeek(date) {
    return this.nth(Math.floor((date.getDate() - 1) / 7 + 1));
  }

  nthLastDayOfWeek(date) {
    return this.nth(Math.floor(((this.lastDayOfMonth(date).getDate() - date.getDate())) / 7 + 1))
  }

  firstDayOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth(), 1)
  }

  lastDayOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth() + 1, 0)
  }

  async appendOccurrenceForm(event) {
    var numberOfNodes = document.getElementById('occurrences').childElementCount;
    event.preventDefault();
    try {
      const response = await fetch(`${this.occurrenceUrlValue}?index=${numberOfNodes}`, {
        method: 'POST',
        headers: {
          'Accept': 'text/vnd.turbo-stream.html'
        }
      });

      if (response.ok) {
        const turboStream = await response.text();
        Turbo.renderStreamMessage(turboStream);
      } else {
        console.error('Failed to load Turbo Stream');
      }
    } catch (error) {
      console.error('Error:', error)
    }
  }

  async appendRecurrenceForm(event) {
    var numberOfNodes = document.getElementById('recurrences').childElementCount;
    event.preventDefault();
    try {
      const response = await fetch(`${this.recurrenceUrlValue}?index=${numberOfNodes}`, {
        method: 'POST',
        headers: {
          'Accept': 'text/vnd.turbo-stream.html'
        }
      });

      if (response.ok) {
        const turboStream = await response.text();
        Turbo.renderStreamMessage(turboStream);
      } else {
        console.error('Failed to load Turbo Stream');
      }
    } catch (error) {
      console.error('Error:', error)
    }
  }

  prefillSlug(event) {
    this.slugTarget.value = event.target.value.toLowerCase().replace(/[^a-z0-9]/g, '_');
  }
}
