class AddUniqueIndexToReports < ActiveRecord::Migration[6.1]
  def change
    add_index :reports, [:user_id, :comment_id], unique: true
  end
end
