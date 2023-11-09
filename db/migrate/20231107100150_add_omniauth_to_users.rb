# frozen_string_literal: true

class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string, null: false
    add_column :users, :username, :string, null: false
    add_index :users, :username, unique: true
  end
end
