# frozen_string_literal: true

# Alarms are responsible for keeping track when to notify of event occurances
class Alarm < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :alarmable, polymorphic: true
  belongs_to :event

  def interval
    calculate_trigger[0]
  end

  def interval=(value)
    @interval = value
    calculate_into_trigger
  end

  def period
    calculate_trigger[1]
  end

  def self.periods
    %w[hour minute second]
  end

  def period=(value)
    return unless Alarm.periods.include?(value)

    @period = value
    calculate_into_trigger
  end

  def alarm_time(_time)
    date - trigger.seconds
  end

  def notification_data(event_occurrence)
    { title: event.name,
      description: description.presence || event.description,
      time: event_occurrence.starts_at }
  end

  private

  def calculate_into_trigger
    return nil unless @period && @interval

    self.trigger = @interval.to_i.send(@period).seconds
  end

  def calculate_trigger
    return [nil, nil] unless trigger
    return [trigger / 3600, 'hour'] if (trigger % 3600).zero?
    return [trigger / 60, 'minute'] if (trigger % 60).zero?

    [trigger, 'second']
  end
end
