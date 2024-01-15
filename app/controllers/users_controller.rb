# frozen_string_literal: true

# Controller related to user actions
class UsersController < ApplicationController
  before_action :set_user, only: [:update]

  def index
    authorize User

    @users = User.all
  end

  def update
    authorize @user

    if @user.update(user_params)
      redirect_to users_url, notice: I18n.t('users.updated')
    else
      redirect_to users_path, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(roles_attributes: [%i[name id _destroy]])
  end
end
