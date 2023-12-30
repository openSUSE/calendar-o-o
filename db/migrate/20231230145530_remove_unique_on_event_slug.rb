class RemoveUniqueOnEventSlug < ActiveRecord::Migration[7.1]
  def change
    remove_index :events, 'slug'
    add_index :events, [:team_id, :slug], unique: true
  end
end
