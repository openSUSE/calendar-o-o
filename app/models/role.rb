# frozen_string_literal: true

# This represents the roles users can have in the application
class Role < ApplicationRecord
  self.implicit_order_column = :name

  belongs_to :user
  enum :name, [:admin]

  # Only one instance of name per user
  validates :name, uniqueness: { scope: :user_id }
end
