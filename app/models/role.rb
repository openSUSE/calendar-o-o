# frozen_string_literal: true

class Role < ApplicationRecord
  self.implicit_order_column = :name

  belongs_to :user
  enum :name, [:admin]

  # Only one instance of name per user
  validates_uniqueness_of :name, scope: :user_id
end
