class CreateInterviews < ActiveRecord::Migration[6.1]
  def change
    create_table :interviews do |t|
      t.references :user, foreign_key: true
      t.string :content, null: false

      t.timestamps
    end
  end
end
