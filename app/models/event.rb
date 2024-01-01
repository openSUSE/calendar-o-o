# frozen_string_literal: true

class Event < ApplicationRecord
  self.implicit_order_column = :starts_at

  belongs_to :team
  has_many :schedule_occurrences, dependent: :destroy
  has_many :schedule_recurrences, dependent: :destroy
  has_many :occurrences, class_name: 'EventOccurrence', dependent: :destroy
  has_many :schedule_exceptions, dependent: :destroy
  has_many :alarms
  accepts_nested_attributes_for :schedule_recurrences,
                                allow_destroy: true
  accepts_nested_attributes_for :schedule_exceptions,
                                allow_destroy: true
  accepts_nested_attributes_for :schedule_occurrences,
                                allow_destroy: true

  validates :slug, format: { with: /\A[a-z0-9_]+\z/, message: 'Has to be alphanumeric with underscores'}
  validates :slug, uniqueness: { scope: :team_id }

  after_save :populate_occurrences

  def to_param
    slug
  end

  def starts_at
    super.in_time_zone(self.timezone) if super
  end

  def ends_at
    super.in_time_zone(self.timezone) if super
  end

  def schedule
    @schedule ||= IceCube::Schedule.new(starts_at, end_time: ends_at) do |s|
      schedule_recurrences.each do |r|
        s.add_recurrence_rule(r.rule)
      end
      schedule_exceptions.each do |x|
        s.add_exception_time(x.time)
      end
      schedule_occurrences.each do |o|
        s.add_recurrence_time(o.time)
      end
    end
  end

  def ievent
    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::DateTime.new starts_at, tzid: ActiveSupport::TimeZone::MAPPING[timezone]
    event.dtend = Icalendar::Values::DateTime.new ends_at, tzid: ActiveSupport::TimeZone::MAPPING[timezone]
    event.summary = name
    event.uid = id.to_s
    event.description = description
    event.created = created_at
    event.last_modified = updated_at
    event.url = Rails.application.routes.url_helpers.team_event_url(team, self)
    event.color = Team::COLOR[team.color.to_sym]
    event.conference = meeting_url
    schedule_recurrences.each do |r|
      event.append_rrule r.rule.to_ical
    end
    schedule_exceptions.each do |x|
      event.append_exdate x.time
    end
    schedule_occurrences.each do |o|
      event.append_rdate o.time
    end

    event
  end

  def icalendar
    ical = Icalendar::Calendar.new

    ical.url = Rails.application.routes.url_helpers.team_event_url(team, self)
    ical.source = Rails.application.routes.url_helpers.team_event_url(team, self, format: :ics)
    ical.color = Team::COLOR[team.color.to_sym]
    ical.add_timezone ActiveSupport::TimeZone.find_tzinfo(timezone).ical_timezone Time.now

    ical.add_event(ievent)
    ical
  end

  def populate_occurrences
    destroy_old_occurrences

    schedule.occurrences(Time.now + 63.days).each do |o|
      next if occurrences.exists?(starts_at: o.start_time, ends_at: o.end_time)

      occurrences << EventOccurrence.new(starts_at: o.start_time, ends_at: o.end_time)
    end
  end

  private

  def destroy_old_occurrences
    occurrences.each do |o|
      all_occurences = schedule.occurrences_between(o.starts_at, o.ends_at)
      next if all_occurences.any? { |a| a.start_time == o.starts_at && a.end_time == o.ends_at }

      o.destroy
    end
  end
end
