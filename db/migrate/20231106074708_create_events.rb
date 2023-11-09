# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.text :slug, null: false
      t.text :meeting_url
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.string :timezone, null: false
      t.references :team, type: :uuid, null: false, foreign_key: true

      t.timestamps
      t.index :slug, unique: true
    end
  end
end
