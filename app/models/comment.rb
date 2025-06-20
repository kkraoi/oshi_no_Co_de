class Comment < ApplicationRecord
  include FormattableDate

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true
end
