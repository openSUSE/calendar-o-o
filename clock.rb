# frozen_string_literal: true

require 'clockwork'
require 'active_support/time'
require './config/boot'
require './config/environment'

# Module for recurring jobs
module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.hour, 'schedule.notifications') do
    EventOccurrence.find_each do |event_occurrence|
      event_occurrence.event.alarms.each do |alarm|
        notification_time = event_occurrence.starts_at - alarm.trigger.seconds
        if notification_time > Time.zone.now && notification_time < 1.hour.from_now
          ::SendNotificationsJob.set(wait_until: notification_time).perform_later(event_occurrence.id, alarm.id)
        end
      end
    end
  end

  every(1.day, 'schedule.occurrences') do
    ::Event.find_each(&:populate_occurrences)
  end
end
