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

  def periods
    ['hour', 'minute', 'second']
  end

  def period=(value)
    return unless periods.include?(value)

    @period = value
    calculate_into_trigger
  end

  def alarm_time(time)
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
    return [ trigger / 3600, 'hour' ] if trigger % 3600 == 0
    return [ trigger / 60, 'minute' ] if trigger % 60 == 0

    [ trigger, 'second' ]
  end
end
