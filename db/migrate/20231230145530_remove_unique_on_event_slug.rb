# frozen_string_literal: true

# Removes unique from the events slug and replaces it with a unique that depends on team_id too
class RemoveUniqueOnEventSlug < ActiveRecord::Migration[7.1]
  def change
    remove_index :events, 'slug'
    add_index :events, %i[team_id slug], unique: true
  end
end
