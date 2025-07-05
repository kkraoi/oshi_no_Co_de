class AddRecommendScoreToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :recommend_score, :decimal, precision: 5, scale: 3
  end
end
