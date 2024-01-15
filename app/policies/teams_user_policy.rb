# frozen_string_literal: true

# Policy that ensures only certain people can create, manage and see team and user association
class TeamsUserPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    return false unless user
    return false if TeamsUser.exists?(user:, team: record.team)
    return false if !user.admin? && record.role != 'member'
    return false if user.admin? && record.role == 'owner'

    true
  end

  def update?
    return false unless user

    user.admin? || record.team.owner == user || record.team.admins.include?(user)
  end

  def destroy?
    return false unless user

    user.admin? || record.user == user || record.team.owner == user || record.team.admins.include?(user)
  end
end
