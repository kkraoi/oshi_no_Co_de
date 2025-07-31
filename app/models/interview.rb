class Interview < ApplicationRecord
  # optional: true => user_id: nil を許容する
  belongs_to :user, optional: true

  validates :content, presence: true
end
