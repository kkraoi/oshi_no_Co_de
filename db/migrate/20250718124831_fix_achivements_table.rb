class FixAchivementsTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :achievements, :false_id, :integer

    change_column_null :achievements, :user_id, false
  end
end
