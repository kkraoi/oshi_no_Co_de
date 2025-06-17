class Code < ApplicationRecord
  belongs_to :post
  belongs_to :language

  validates :name, presence: true
  validates :content, presence: true
  validates :language_id, presence: true
end
