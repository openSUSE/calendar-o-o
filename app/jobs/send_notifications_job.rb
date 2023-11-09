class SendNotificationsJob < ApplicationJob
  queue_as :default

  def perform(event_occurrence_id, alarm_id)
    alarm = Alarm.find(alarm_id)
    event_occurrence = EventOccurrence.find(event_occurrence_id)

    if alarm.class == AlarmNotification
      NotificationChannel.broadcast_to(alarm.alarmable, alarm.notification_data(event_occurrence))
    elsif alarm.class == AlarmEmail
      NotificationMailer.notification_email(event_occurrence, alarm).deliver_now
    end
  end
end
