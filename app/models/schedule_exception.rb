# frozen_string_literal: true

# This represents icalendar schedule's exeption dates
class ScheduleException < ApplicationRecord
  self.implicit_order_column = :time

  belongs_to :event

  def time
    super&.in_time_zone(event.timezone)
  end
end
