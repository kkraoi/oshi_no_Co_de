class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true 
      t.references :commentable, polymorphic: true, null: false # 投稿 or グループ
      t.text :content, null: false

      t.timestamps
    end
  end
end
