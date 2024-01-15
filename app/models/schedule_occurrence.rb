# frozen_string_literal: true

# This represents icalendar schedule's occurrence dates (single occurrences)
class ScheduleOccurrence < ApplicationRecord
  belongs_to :event

  def time
    super&.in_time_zone(event.timezone)
  end
end
