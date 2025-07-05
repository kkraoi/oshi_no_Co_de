class ChangeRecommendScoreToInteger < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        Post.where(recommend_score: nil).update_all(recommend_score: nil)
      end
    end

    change_column :posts, :recommend_score, :integer, default: 0, null: false
  end
end
