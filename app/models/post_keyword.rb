class PostKeyword < ApplicationRecord
  belongs_to :post

  validates :name, presence: true
  validates :salience, presence: true
  validates :entity_type, presence: true
end
