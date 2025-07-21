class FixAchievementsInitialMigration < ActiveRecord::Migration[6.1]
  def up
    # 外部キー制約を削除（存在する場合）
    if foreign_key_exists?(:achievements, column: :false_id)
      remove_foreign_key :achievements, column: :false_id
    end
    
    # false_idカラムを削除（存在する場合）
    if column_exists?(:achievements, :false_id)
      remove_column :achievements, :false_id
    end
    
    # 正しいuser_idカラムを追加（存在しない場合）
    unless column_exists?(:achievements, :user_id)
      add_reference :achievements, :user, null: false, foreign_key: true
    end
  end
  
  def down
    # ロールバック用（必要に応じて）
    add_column :achievements, :false_id, :integer unless column_exists?(:achievements, :false_id)
  end
end
