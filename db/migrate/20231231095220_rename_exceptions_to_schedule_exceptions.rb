class RenameExceptionsToScheduleExceptions < ActiveRecord::Migration[7.1]
  def change
    rename_table :event_exceptions, :schedule_exceptions
  end
end
