class AddSentimentScoreToComments < ActiveRecord::Migration[6.1]
  def change
    # precision: 5 => 合計5桁
    # scale: 3 => 少数3桁
    add_column :comments, :sentiment_score, :decimal, precision: 5, scale: 3
  end
end
