# frozen_string_literal: true

# This represents icalendar schedule's recurrence dates (unlimited occurrences)
class ScheduleRecurrence < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :event
  enum :frequency, %w[day week month year]
  enum :month_type, %w[nth_of_month nth_weekday_of_month nth_last_weekday_of_month]

  FREQUENCY_METRIC = { day: :daily, week: :weekly, month: :monthly, year: :yearly }.freeze

  after_save ->(r) { r.event.populate_occurrences }

  def rule
    rule = build_base_rule

    rule.day(*week_days.compact) if weekly_with_weekdays?

    rule = apply_month_rules(rule) if monthly?

    rule.until(ends_at) if ends_at

    rule
  end

  def ends_at
    super&.in_time_zone(event.timezone)
  end

  private

  def build_base_rule
    IceCube::Rule.send(FREQUENCY_METRIC[frequency.to_sym], interval)
  end

  def weekly_with_weekdays?
    frequency == 'week' && week_days.present?
  end

  def monthly?
    frequency == 'month'
  end

  def apply_month_rules(rule)
    case month_type
    when 'nth_of_month' then rule.day_of_month(event.starts_at.day)
    when 'nth_weekday_of_month' then apply_nth_weekday_rules(rule)
    when 'nth_last_weekday_of_month' then apply_nth_last_weekday_rules(rule)
    end

    rule
  end

  def apply_nth_weekday_rules(rule)
    rule.day_of_week({ event.starts_at.wday => [nth_weekday(event.starts_at)] })
  end

  def apply_nth_last_weekday_rules(rule)
    day_of_week = event.starts_at.wday
    rule.day_of_week({ day_of_week => [-nth_last_weekday(event.starts_at)] })
  end

  def nth_weekday(date)
    ((date.day - 1) / 7) + 1
  end

  def nth_last_weekday(date)
    date.end_of_month
    (((date.end_of_month.day - date.day)) / 7) + 1
  end
end
