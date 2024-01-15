# frozen_string_literal: true

# Policy that ensures only certain people can destroy event occurrences
class EventOccurrencePolicy < ApplicationPolicy
  def destroy?
    return false unless user

    user.admin? || record.event.team.owner == user || record.event.team.admins.include?(user)
  end
end
