class ChangeRecommendScoreDefaultInPosts < ActiveRecord::Migration[6.1]
  def change
    change_column_default :posts, :recommend_score, from: nil, to: 0.0
  end
end
