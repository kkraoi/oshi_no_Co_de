class Like < ApplicationRecord
  belongs_to :user
  # counter_cach => 子モデルの数を親モデルのカラムに保存。これにより、Like が作成／削除されるたびに、自動で posts.likes_count が更新される。
  belongs_to :post, counter_cache: true
end
