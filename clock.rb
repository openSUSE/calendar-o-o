require 'clockwork'
require 'active_support/time'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.hours, 'schedule.notifications') do
    EventOccurrence.all.each do |event_occurrence|
      event_occurrence.event.alarms.each do |alarm|
        notification_time = event_occurrence.starts_at - alarm.trigger.seconds
        if notification_time > Time.now && notification_time < Time.now + 1.hours
          ::SendNotificationsJob.set(wait_until: notification_time).perform_later(event_occurrence.id, alarm.id)
        end
      end
    end
  end

  every(1.days, 'schedule.occurrences') do
    ::Event.all.each do |event|
      event.populate_occurrences
    end
  end
end
