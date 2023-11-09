# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.integer :name, null: false

      t.timestamps
    end
  end
end
