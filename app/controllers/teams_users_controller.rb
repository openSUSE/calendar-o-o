# frozen_string_literal: true

class TeamsUsersController < ApplicationController
  before_action :set_team
  before_action :set_teams_user, only: %i[show edit update destroy]

  def show
    authorize @teams_user
  end

  def create
    @teams_user = authorize TeamsUser.new(teams_user_params.permit(:team_id).with_defaults(user_id: current_user.id, role: :member))

    if @teams_user.save
      redirect_to team_url(@team), notice: 'Team membership has been created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @teams_user
  end

  def update
    authorize @teams_user

    if @teams_user.update(teams_user_params)
      redirect_to team_url(@team), notice: 'Team membership has been updated!'
    else
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @teams_user

    @teams_user.destroy
    redirect_to team_url(@team), notice: 'Team membership removed'
  end

  private

  def teams_user_params
    params.require(:teams_user).permit(:user_id, :team_id, :role)
  end
end
