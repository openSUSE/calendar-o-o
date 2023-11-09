# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy]

  def index
    @teams = Team.all
    @teams = User.find_by(username: params[:user]).teams if params[:user].present? && User.exists?(username: params[:user])
  end

  def show
    authorize @team

    respond_to do |format|
      format.html
      format.ics { render plain: @team.icalendar.to_ical, content_type: 'text/calendar' }
    end
  end

  def new
    @team = authorize Team.new
  end

  def create
    @team = authorize Team.new(team_params)

    if @team.save
      redirect_to team_url(@team), notice: 'Team has been created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @team
  end

  def update
    authorize @team

    if @team.update(team_params)
      redirect_to team_url(@team), notice: 'Team has been updated!'
    else
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @team

    @team.destroy
    redirect_to teams_url, notice: 'Team removed'
  end

  private

  def team_params
    params.require(:team).permit(:name, :slug, :color)
  end
end
