# frozen_string_literal: true

# Controller related to the main page actions
class MainController < ApplicationController
  ICALENDAR_DETAILS = {
    description: Rails.configuration.site[:tagline],
    url: Rails.application.routes.url_helpers.root_url,
    source: Rails.application.routes.url_helpers.main_index_url(format: :ics)
  }.freeze

  def index
    # Only show the events that haven't ended yet
    @event_occurrences = EventOccurrence.where('starts_at > ?',
                                               Time.zone.today.monday.beginning_of_day).order(:starts_at)
    @days_with_events = @event_occurrences.select(:starts_at).distinct.pluck(:starts_at).map(&:to_date)

    respond_to do |format|
      format.html
      format.ics { render plain: icalendar.to_ical, content_type: 'text/calendar' }
    end
  end

  private

  def icalendar
    Icalendar::Calendar.new.tap do |ical|
      ICALENDAR_DETAILS.each do |prop, value|
        ical.send("#{prop}=", value)
      end

      add_timezones_to_icalendar(ical)
      Event.find_each { |event| ical.add_event(event.ievent) }
    end
  end

  def add_timezones_to_icalendar(ical)
    Event.select(:timezone).distinct.pluck(:timezone).each do |timezone|
      ical.add_timezone(ActiveSupport::TimeZone.find_tzinfo(timezone).ical_timezone(Time.zone.now))
    end
  end
end
