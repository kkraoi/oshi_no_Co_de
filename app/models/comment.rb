class Comment < ApplicationRecord
  include FormattableDate

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :reports, dependent: :destroy

  validates :content, presence: true
end
