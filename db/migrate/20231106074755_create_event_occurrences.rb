# frozen_string_literal: true

class CreateEventOccurrences < ActiveRecord::Migration[7.1]
  def change
    create_table :event_occurrences, id: :uuid do |t|
      t.references :event, type: :uuid, null: false, foreign_key: true
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false

      t.timestamps
    end
  end
end
