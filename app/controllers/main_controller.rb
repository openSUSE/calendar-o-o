# frozen_string_literal: true

class MainController < ApplicationController
  def index
    # Only show the events that haven't ended yet
    @event_occurrences = EventOccurrence.where('starts_at > ?', Date.today.monday).order(:starts_at)
    @days_with_events = @event_occurrences.select(:starts_at).distinct.pluck(:starts_at).map(&:to_date)

    respond_to do |format|
      format.html
      format.ics { render plain: icalendar.to_ical, content_type: 'text/calendar' }
    end
  end

  def icalendar
    cal = Icalendar::Calendar.new
    cal.description = Rails.configuration.site[:tagline]
    cal.url = root_url
    cal.source = main_index_url(format: :ics)

    Event.all.select(:timezone).distinct.pluck(:timezone).each do |timezone|
      cal.add_timezone ActiveSupport::TimeZone.find_tzinfo(timezone).ical_timezone Time.now
    end

    Event.all.each do |event|
      cal.add_event event.ievent
    end
    cal
  end
end
