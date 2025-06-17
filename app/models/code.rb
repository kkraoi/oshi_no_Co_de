class Code < ApplicationRecord
  belongs_to :post
  belongs_to :language

  validates :name, presence: true
  validates :content, presence: true
end
