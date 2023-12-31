# frozen_string_literal: true

class ScheduleRecurrence < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :event
  enum :frequency, %w[day week month year]
  enum :month_type, %w[nth_of_month nth_weekday_of_month nth_last_weekday_of_month]

  FREQUENCY_METRIC = { day: :daily, week: :weekly, month: :monthly, year: :yearly }.freeze

  after_save ->(r) { r.event.populate_occurrences }

  def rule
    rule = IceCube::Rule.send(FREQUENCY_METRIC[frequency.to_sym], interval)

    rule.day(*week_days.compact) if frequency == 'week' && week_days.present?

    rule = month_rules(rule) if frequency == 'month'

    rule.until(ends_at) if ends_at

    rule
  end

  def ends_at
    super.in_time_zone(event.timezone) if super
  end

  private

  def month_rules(rule)
    case month_type
    when 'nth_of_month'
      rule.day_of_month(event.starts_at.day)
    when 'nth_weekday_of_month'
      rule.day_of_week(nth_weekday(event.starts_at))
    when 'nth_last_weekday_of_month'
      rule.day_of_week(-nth_last_weekday(event.starts_at))
    end

    rule
  end

  def nth_weekday(date)
    (date.day - 1) / 7 + 1
  end

  def nth_last_weekday(date)
    date.end_of_month
    ((date.end_of_month.day - date.day)) / 7 + 1
  end
end
