# frozen_string_literal: true

# Creates teams and users association
class CreateTeamsUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :teams_users, id: :uuid do |t|
      t.references :team, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
