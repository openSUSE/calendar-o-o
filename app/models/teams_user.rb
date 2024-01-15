# frozen_string_literal: true

# Relationship between teams and users that includes a role they have in the team
class TeamsUser < ApplicationRecord
  self.implicit_order_column = :role

  belongs_to :team
  belongs_to :user
  enum :role, %w[member admin owner]

  # Only one instance for user per team
  validates :user, uniqueness: { scope: :team_id }
  validate :only_one_owner_per_team

  private

  def only_one_owner_per_team
    return unless role == 'owner' && team.teams_users.exists?(role: 'owner')

    errors.add(:base, 'Only one owner allowed per team')
  end
end
