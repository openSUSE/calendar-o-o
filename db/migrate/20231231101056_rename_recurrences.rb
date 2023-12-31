class RenameRecurrences < ActiveRecord::Migration[7.1]
  def change
    rename_table :recurrences, :schedule_recurrences
  end
end
