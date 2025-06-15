class Post < ApplicationRecord
  belongs_to :user

  # 指定された日時属性を日本時間で「YYYY/MM/DD」形式に整形して返す
  #
  # @param attribute [Symbol] 整形対象の日付属性。デフォルトは :updated_at
  # @return [String] フォーマット済みの日付（例: "2025/06/15"）
  def format_date(attribute = :update_at)
    self[attribute].in_time_zone("Asia/Tokyo").strftime("%Y/%m/%d")
  end
end
