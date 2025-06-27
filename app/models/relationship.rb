class Relationship < ApplicationRecord
  # 同じテーブル同士を結んでいる。
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
