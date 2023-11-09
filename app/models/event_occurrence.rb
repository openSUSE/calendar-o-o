# frozen_string_literal: true

class EventOccurrence < ApplicationRecord
  self.implicit_order_column = :starts_at

  belongs_to :event

  def exclude
    event.exceptions << EventException.new(time: starts_at)
    event.save!
  end
end
