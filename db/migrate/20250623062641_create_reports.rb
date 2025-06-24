class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.text :reason, null: false
      t.boolean :resolved, default: false
      t.text :admin_feedback

      t.timestamps
    end
  end
end
