class AddForeignKeyToAchievementsUser < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :achievements, :users
  end
end
