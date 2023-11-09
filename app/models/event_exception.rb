# frozen_string_literal: true

class EventException < ApplicationRecord
  self.implicit_order_column = :time

  belongs_to :event

  def time
    super.in_time_zone(event.timezone) if super
  end
end
