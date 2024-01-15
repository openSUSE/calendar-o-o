# frozen_string_literal: true

# Controller related to schedule occurrences actions
class ScheduleOccurrencesController < ApplicationController
  before_action :set_team
  before_action :set_event

  def create
    @index = params[:index]
    respond_to(&:turbo_stream)
  end
end
