# frozen_string_literal: true

# Policy that ensures only certain people can create, manage and see events
class EventPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    return false unless user

    user.admin? || record.team.owner == user || record.team.admins.include?(user)
  end

  def update?
    return false unless user

    user.admin? || record.team.owner == user || record.team.admins.include?(user)
  end

  def destroy?
    return false unless user

    user.admin? || record.team.owner == user || record.team.admins.include?(user)
  end
end
