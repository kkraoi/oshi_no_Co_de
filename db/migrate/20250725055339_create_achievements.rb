class CreateAchievements < ActiveRecord::Migration[6.1]
  def change
    create_table :achievements do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :link

      t.timestamps
    end
  end
end
