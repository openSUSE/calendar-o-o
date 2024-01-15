# frozen_string_literal: true

# Creates team table
class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.text :slug, null: false
      t.integer :color

      t.timestamps
      t.index :slug, unique: true
    end
  end
end
