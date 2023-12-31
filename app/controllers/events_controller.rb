# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_team
  before_action :set_event, only: %i[show edit update destroy]

  def show
    authorize @event

    respond_to do |format|
      format.html
      format.ics { render plain: @event.icalendar.to_ical, content_type: 'text/calendar' }
    end
  end

  def new
    @event = authorize @team.events.new
  end

  def create
    @event = @team.events.new(event_parameters)

    if @event.save
      redirect_to team_event_url(@team, @event), notice: 'Event has been created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @event
  end

  def update
    authorize @event

    if @event.update(event_parameters)
      redirect_to team_event_url(@team, @event), notice: 'Event has been updated!'
    else
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event

    @event.destroy
    redirect_to team_url(@team), notice: 'Event removed'
  end

  private

  def event_parameters
    event_params = params.require(:event).permit(:name, :slug, :description, :meeting_url, :starts_at, :ends_at, :timezone,
                                                 recurrences_attributes: [[:id, :interval, :frequency, :_destroy, :month_type, :ends_at, { week_days: [] }]],
                                                 schedule_exceptions_attributes: [[:id, :time, :_destroy]])

    # Makes sure to set the right timezone for the parameters, otherwise they get interpreted with UTC
    if (timezone = ActiveSupport::TimeZone[event_params[:timezone] || @event&.timezone])
      event_params[:starts_at] = timezone.parse(event_params[:starts_at])
      event_params[:ends_at] = timezone.parse(event_params[:ends_at])
      
      event_params[:recurrences_attributes]&.each do |index, recurrence|
        recurrence[:ends_at] = timezone.parse(recurrence[:ends_at]) if recurrence[:ends_at]
      end

      event_params[:schedule_exceptions_attributes]&.each do |index, exception|
        exception[:time] = timezone.parse(exception[:time]) if exception[:time]
      end
    end

    event_params
  end
end
