# frozen_string_literal: true

# This represents the event object
class Event < ApplicationRecord
  self.implicit_order_column = :starts_at

  belongs_to :team
  has_many :schedule_occurrences, dependent: :destroy
  has_many :schedule_recurrences, dependent: :destroy
  has_many :occurrences, class_name: 'EventOccurrence', dependent: :destroy
  has_many :schedule_exceptions, dependent: :destroy
  has_many :alarms, dependent: :destroy
  accepts_nested_attributes_for :schedule_recurrences,
                                allow_destroy: true
  accepts_nested_attributes_for :schedule_exceptions,
                                allow_destroy: true
  accepts_nested_attributes_for :schedule_occurrences,
                                allow_destroy: true

  validates :slug,
            format: { with: /\A[a-z0-9_-]+\z/, message: I18n.t('format_validation.alphanumeric_with_dashes') }
  validates :slug, uniqueness: { scope: :team_id }

  after_save :populate_occurrences

  IEVENT_DETAILS = {
    summary: ->(event) { event.name },
    uid: ->(event) { event.id.to_s },
    description: ->(event) { event.description },
    x_alt_desc: ->(event) { Icalendar::Values::Text.new(event.html_description, { 'FMTTYPE' => 'text/html' }) },
    dtstart: ->(event) { event.ical_time(event.starts_at) },
    dtend: ->(event) { event.ical_time(event.ends_at) },
    created: ->(event) { event.ical_time(event.created_at) },
    last_modified: ->(event) { event.ical_time(event.updated_at) },
    color: ->(event) { Team::COLOR[event.team.color.to_sym] },
    url: ->(event) { Rails.application.routes.url_helpers.team_event_url(event.team, event) },
    conference: ->(event) { event.meeting_url }
  }.freeze

  ICALENDAR_DETAILS = {
    color: ->(event) { Team::COLOR[event.team.color.to_sym] },
    url: ->(event) { Rails.application.routes.url_helpers.team_event_url(event.team, event) },
    source: ->(event) { Rails.application.routes.url_helpers.team_event_url(event.team, event, format: :ics) }
  }.freeze

  def to_param
    slug
  end

  def starts_at
    super&.in_time_zone(timezone)
  end

  def ends_at
    super&.in_time_zone(timezone)
  end

  def schedule
    @schedule ||= IceCube::Schedule.new(starts_at, end_time: ends_at) do |s|
      schedule_recurrences.each { |r| s.add_recurrence_rule(r.rule) }
      schedule_exceptions.each { |x| s.add_exception_time(x.time) }
      schedule_occurrences.each { |o| s.add_recurrence_time(o.time) }
    end
  end

  def ievent
    event = Icalendar::Event.new
    IEVENT_DETAILS.each do |prop, value|
      event.send("#{prop}=", value.call(self))
    end
    event_time_properties(event)
    event
  end

  def icalendar
    Icalendar::Calendar.new.tap do |ical|
      ICALENDAR_DETAILS.each do |prop, value|
        ical.send("#{prop}=", value.call(self))
      end
      ical.add_timezone(ical_timezone)
      ical.add_event(ievent)
    end
  end

  def populate_occurrences
    destroy_old_occurrences

    schedule.occurrences(63.days.from_now)&.each do |o|
      next if occurrences.exists?(starts_at: o.start_time, ends_at: o.end_time)

      occurrences << EventOccurrence.new(starts_at: o.start_time, ends_at: o.end_time)
    end
  end

  def html_description
    Kramdown::Document.new(description, input: 'GFM').to_html
  end

  def ical_time(time)
    Icalendar::Values::DateTime.new time, tzid: ActiveSupport::TimeZone::MAPPING[timezone]
  end

  private

  def destroy_old_occurrences
    occurrences&.each do |o|
      all_occurences = schedule.occurrences_between(o.starts_at, o.ends_at)
      next if all_occurences.any? { |a| a.start_time == o.starts_at && a.end_time == o.ends_at }

      o.destroy
    end
  end

  def event_time_properties(event)
    schedule_recurrences.each { |r| event.append_rrule(r.rule.to_ical) }
    schedule_exceptions.each { |x| event.append_exdate(ical_time(x.time)) }
    schedule_occurrences.each { |o| event.append_rdate(ical_time(o.time)) }
  end

  def ical_timezone
    tzinfo = ActiveSupport::TimeZone.find_tzinfo(timezone)
    tzinfo.ical_timezone(Time.zone.now)
  end
end
