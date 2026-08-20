# frozen_string_literal: true

# Adds omniauth handling to users table
class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  # rubocop:disable Rails/NotNullColumn
  def change
    change_table :users, bulk: true do |t|
      t.string :provider
      t.string :uid
      t.string :name, null: false
      t.string :username, null: false
      t.index :username, unique: true
    end
  end
  # rubocop:enable Rails/NotNullColumn
end
