# frozen_string_literal: true

class CreateRecurrences < ActiveRecord::Migration[7.1]
  def change
    create_table :recurrences, id: :uuid do |t|
      t.references :event, type: :uuid, null: false, foreign_key: true
      t.integer :interval, null: false
      t.integer :frequency, null: false
      t.integer :week_days, array: true
      t.integer :month_type
      t.datetime :ends_at

      t.timestamps
    end
  end
end
