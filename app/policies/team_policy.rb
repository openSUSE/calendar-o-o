# frozen_string_literal: true

class TeamPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    return false unless user

    user.admin?
  end

  def update?
    return false unless user

    user.admin? || record.owner == user || record.admins.include?(user)
  end

  def destroy?
    return false unless user

    user.admin? || record.owner == user
  end
end
