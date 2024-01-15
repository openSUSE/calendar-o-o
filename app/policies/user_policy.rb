# frozen_string_literal: true

# Policy that ensures only certain people can create, manage and see users
class UserPolicy < ApplicationPolicy
  def index?
    return false unless user

    user.admin?
  end

  def update?
    return false unless user

    user.admin?
  end
end
