class CreateAlarms < ActiveRecord::Migration[7.1]
  def change
    create_table :alarms, id: :uuid do |t|
      t.references :event, type: :uuid, null: false
      t.string :type, null: false
      t.string :email
      t.integer :trigger, null: false
      t.text :description
      t.references :alarmable, type: :uuid, polymorphic: true, null: false

      t.timestamps
    end
  end
end
