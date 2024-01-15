# frozen_string_literal: true

# Renames recurrencees table to align with usage
class RenameRecurrences < ActiveRecord::Migration[7.1]
  def change
    rename_table :recurrences, :schedule_recurrences
  end
end
