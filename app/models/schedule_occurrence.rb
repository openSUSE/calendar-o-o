class ScheduleOccurrence < ApplicationRecord
  belongs_to :event

  def time
    super.in_time_zone(event.timezone) if super
  end
end
