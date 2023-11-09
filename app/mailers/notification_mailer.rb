class NotificationMailer < ApplicationMailer
  def notification_email(event_occurrence, alarm)
    @event_occurrence = event_occurrence
    @alarm = alarm
    @date = event_occurrence.starts_at.in_time_zone(event_occurrence.event.timezone)
    @email = alarm.email.presence || alarm.alarmable&.email
    mail(to: @email, subject: "Meeting reminder: #{alarm.event.name} #{date_to_string}") do |format|
      format.text
    end
  end

  private

  def date_to_string
    today = Date.current
    time = @date.strftime('(%H:%M %Z)')

    case (@date.to_date - today).to_i
    when 0
      "today #{time}"
    when 1
      "tommorow #{time}"
    when 1..6
      "next #{@date.strftime('%A')} #{time}"
    else
      @date.strftime('%B %e')
    end
  end
end
