# frozen_string_literal: true

# Creates event exceptions table
class CreateEventExceptions < ActiveRecord::Migration[7.1]
  def change
    create_table :event_exceptions, id: :uuid do |t|
      t.datetime :time, null: false
      t.references :event, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
