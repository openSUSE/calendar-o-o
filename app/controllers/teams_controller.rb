# frozen_string_literal: true

# Controller related to team actions
class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy]

  def index
    @teams = Team.order(:name)
    return unless params[:user].present? && User.exists?(username: params[:user])

    @teams = User.find_by(username: params[:user]).teams
  end

  def show
    authorize @team
    username_table = User.arel_table['username']
    role_table = TeamsUser.arel_table['role']
    @teams_users_in_roles = @team.teams_users.joins(:user).order(username_table).order(role_table).group_by(&:role)

    respond_to do |format|
      format.html
      format.ics { render plain: @team.icalendar.to_ical, content_type: 'text/calendar' }
    end
  end

  def new
    @team = authorize Team.new
  end

  def edit
    authorize @team
  end

  def create
    @team = authorize Team.new(team_params)

    if @team.save
      redirect_to team_url(@team), notice: I18n.t('teams.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @team

    if @team.update(team_params)
      redirect_to team_url(@team), notice: I18n.t('teams.updated')
    else
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @team

    @team.destroy
    redirect_to teams_url, notice: I18n.t('teams.removed')
  end

  private

  def team_params
    params.require(:team).permit(:name, :slug, :color)
  end
end
