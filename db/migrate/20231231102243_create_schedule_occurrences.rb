class CreateScheduleOccurrences < ActiveRecord::Migration[7.1]
  def change
    create_table :schedule_occurrences, id: :uuid do |t|
      t.references :event, null: false, foreign_key: true, type: :uuid
      t.datetime :time

      t.timestamps
    end
  end
end
