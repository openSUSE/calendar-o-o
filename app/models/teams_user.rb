# frozen_string_literal: true

class TeamsUser < ApplicationRecord
  self.implicit_order_column = :role

  belongs_to :team
  belongs_to :user
  enum :role, %w[member admin owner]

  # Only one instance for user per team
  validates_uniqueness_of :user, scope: :team_id
  validates_uniqueness_of :team, conditions: -> { where(role: 'owner') }
end
