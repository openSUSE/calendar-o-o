# frozen_string_literal: true

class EventOccurrencesController < ApplicationController
  before_action :set_team
  before_action :set_event
  before_action :set_event_occurrence

  def destroy
    authorize @event_occurrence

    @event_occurrence.exclude
    redirect_to team_event_url(@team, @event), notice: 'Event occurrence removed'
  end
end
