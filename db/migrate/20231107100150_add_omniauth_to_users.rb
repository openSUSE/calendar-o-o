# frozen_string_literal: true

# Adds omniauth handling to users table
class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :provider
      t.string :uid
      t.string :name, null: false
      t.string :username, null: false
      t.index :username, unique: true
    end
  end
end
