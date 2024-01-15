# frozen_string_literal: true

# Policy that ensures only certain people can create, manage and see alarms
class AlarmPolicy < ApplicationPolicy
  # Creates a scope that lets users see alarms they are responsible for
  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user
        team_alarmables = user.teams_users.where(role: %i[owner admin]).pluck(:team_id)
        scope.where(alarmable: user).or(scope.where(alarmable: team_alarmables))
      end
    end
  end

  def index?
    return false unless user

    true
  end

  def create?
    return false unless user
    return false if !team_create? && record.alarmable != user

    true
  end

  def team_create?
    return false unless user

    admins?
  end

  def update?
    return false unless user
    return false if !team_create? && record.alarmable != user

    true
  end

  def destroy?
    return false unless user

    record.alarmable == user || admins?
  end

  private

  def admins?
    user.admin? || record.event.team.owner == user || record.event.team.admins.include?(user)
  end
end
