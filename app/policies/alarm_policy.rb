# frozen_string_literal: true

class AlarmPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user
        team_alarmables = user.teams_users.where(role: [:owner, :admin]).pluck(:team)
        scope.where(alarmable: user).and(where(alarmable: team_alarmables))
      end
    end
  end

  def index?
    return false unless user

    true
  end

  def create?
    return false unless user
    return false if !(team_create?) && record.alarmable != user

    true
  end
  
  def team_create?
    return false unless user

    user.admin? || record.event.team.owner == user || record.event.team.admins.include?(user)
  end

  def update?
    return false unless user
    return false if !(team_create?) && record.alarmable != user

    true
  end

  def destroy?
    return false unless user

    user.admin? || record.user == user
  end
end
