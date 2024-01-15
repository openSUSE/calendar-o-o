# frozen_string_literal: true

# This is stored as quick access persistent cache to know when the event happens on the schedule
class EventOccurrence < ApplicationRecord
  self.implicit_order_column = :starts_at

  belongs_to :event

  def exclude
    event.schedule_exceptions << ScheduleException.new(time: starts_at)
    event.save!
  end
end
