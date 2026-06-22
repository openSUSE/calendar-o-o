# frozen_string_literal: true

# This represents icalendar schedule's occurrence dates (single occurrences)
class ScheduleOccurrence < ApplicationRecord
  belongs_to :event

  validates :time, presence: true

  def time
    super&.in_time_zone(event.timezone)
  end
end
