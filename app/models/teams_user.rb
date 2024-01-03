# frozen_string_literal: true

class TeamsUser < ApplicationRecord
  self.implicit_order_column = :role

  belongs_to :team
  belongs_to :user
  enum :role, %w[member admin owner]

  # Only one instance for user per team
  validates_uniqueness_of :user, scope: :team_id
  validate :only_one_owner_per_team

  private

  def only_one_owner_per_team
    if role == 'owner' && team.team_users.where(role: 'owner').exists?
      errors.add(:base, 'Only one owner allowed per team')
    end
  end
end
