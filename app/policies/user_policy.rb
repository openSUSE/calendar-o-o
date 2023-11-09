# frozen_string_literal: true

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
