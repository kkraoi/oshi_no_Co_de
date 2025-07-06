class CreatePostKeywords < ActiveRecord::Migration[6.1]
  def change
    create_table :post_keywords do |t|
      t.references :post, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :salience, precision: 5, scale: 3, null: false
      t.string :entity_type, null: false
      t.timestamps
    end
  end
end
