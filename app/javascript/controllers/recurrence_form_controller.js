import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "repeat", "interval", "frequency", "month", "week", "recurrenceEndsAt" ]

  connect() {
    this.showRecurrence();
  }

  recurrence(event) {
    this.showRecurrence();
  }

  showRecurrence() {
    this.hideRecurrence();
    if (this.repeatTarget.checked === false) {
      switch(this.frequencyTarget.selectedOptions[0].value) {
        case "week":
          this.show(this.weekTarget);
          break;
        case "month":
          this.show(this.monthTarget);
      } 
      this.show(this.recurrenceEndsAtTarget);
      this.intervalTarget.disabled = false;
      this.frequencyTarget.disabled = false;
    }
  }

  show(target) {
    target.classList.remove("d-none")
  }

  hideRecurrence() {
    this.hide(this.weekTarget);
    this.hide(this.monthTarget);
    this.hide(this.recurrenceEndsAtTarget);
    this.intervalTarget.disabled = true;
    this.frequencyTarget.disabled = true;
  }

  hide(target) {
    target.classList.add("d-none")
  }
}
