# frozen_string_literal: true

# Controller related to team and user association
class TeamsUsersController < ApplicationController
  before_action :set_team
  before_action :set_teams_user, only: %i[show edit update destroy]

  def show
    authorize @teams_user
  end

  def edit
    authorize @teams_user
  end

  def create
    @teams_user = authorize TeamsUser.new(teams_user_create_params)

    if @teams_user.save
      redirect_to team_url(@team), notice: I18n.t('teams_users.created')
    else
      redirect_to team_url(@team),
                  notice: I18n.t('teams.users.create_failed', errors: @teams_user.errors.full_messages.to_sentence)
    end
  end

  def update
    authorize @teams_user

    if @teams_user.update(team_user_update_params)
      redirect_to team_url(@team), notice: I18n.t('teams_users.updated')
    else
      redirect_to team_url(@team),
                  notice: I18n.t('teams.users.update_failed', errors: @teams_user.errors.full_messages.to_sentence)
    end
  end

  def destroy
    authorize @teams_user

    @teams_user.destroy
    redirect_to team_url(@team), notice: I18n.t('teams_users.removed')
  end

  private

  def teams_user_create_params
    params.require(:teams_user).permit(:team_id).with_defaults(user_id: current_user.id, role: :member)
  end

  def team_user_update_params
    params.require(:teams_user).permit(:role)
  end
end
