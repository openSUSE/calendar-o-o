# frozen_string_literal: true

# Adds unique indexes to tables
class AddUniquenessToTables < ActiveRecord::Migration[7.1]
  def change
    add_index :roles, %i[user_id name], unique: true
    add_index :teams_users, %i[team_id user_id], unique: true
  end
end
