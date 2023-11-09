# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:update]

  def index
    authorize User

    @users = User.all
  end

  def update
    authorize @user

    if @user.update(user_params)
      redirect_to users_url, notice: 'User has been updated!'
    else
      redirect_to users_path, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(roles_attributes: [[:name, :id, :_destroy]])
  end
end
