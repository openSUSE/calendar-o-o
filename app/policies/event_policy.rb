# frozen_string_literal: true

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
