# frozen_string_literal: true

# Controller related to event actions
class EventsController < ApplicationController
  before_action :set_team
  before_action :set_event, only: %i[show edit update destroy]

  def show
    authorize @event
    @dated_occurrences = @event.occurrences.where('starts_at > ?',
                                                  Date.yesterday).order('starts_at ASC').group_by do |o|
      o.starts_at.strftime('%B %Y')
    end

    respond_to do |format|
      format.html
      format.ics { render plain: @event.icalendar.to_ical, content_type: 'text/calendar' }
    end
  end

  def new
    @event = authorize @team.events.new
  end

  def edit
    authorize @event
  end

  def create
    @event = @team.events.new(event_parameters)

    if @event.save
      redirect_to team_event_url(@team, @event), notice: I18n.t('events.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @event

    if @event.update(event_parameters)
      redirect_to team_event_url(@team, @event), notice: I18n.t('events.updated')
    else
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event

    @event.destroy
    redirect_to team_url(@team), notice: I18n.t('events.removed')
  end

  private

  def event_parameters
    event_params = params.require(:event).permit(
      :name, :slug, :description, :meeting_url, :starts_at, :ends_at, :timezone,
      schedule_recurrences_attributes: [
        [:id, :interval, :frequency, :_destroy, :month_type, :ends_at, { week_days: [] }]
      ],
      schedule_exceptions_attributes: [%i[id time _destroy]],
      schedule_occurrences_attributes: [%i[id time _destroy]]
    )

    apply_timezone_conversion(event_params)

    event_params
  end

  def apply_timezone_conversion(event_params)
    return unless (timezone = ActiveSupport::TimeZone[event_params[:timezone] || @event&.timezone])

    convert_time_attributes(event_params, timezone, %i[starts_at ends_at])
    convert_nested_attributes(event_params, timezone, :schedule_recurrences_attributes, :ends_at)
    convert_nested_attributes(event_params, timezone, :schedule_exceptions_attributes, :time)
    convert_nested_attributes(event_params, timezone, :schedule_occurrences_attributes, :time)
  end

  def convert_time_attributes(params, timezone, attributes)
    attributes.each { |attribute| params[attribute] = convert_time_with_zone(params[attribute], timezone) }
  end

  def convert_nested_attributes(params, timezone, nested_attribute, nested_attribute_key)
    elements = params[nested_attribute]
    return unless elements

    elements.each_value do |element|
      convert_time_attributes(element, timezone, [nested_attribute_key]) if element[nested_attribute_key]
    end
  end

  def convert_time_with_zone(time, timezone)
    timezone.parse(time) if time
  end
end
