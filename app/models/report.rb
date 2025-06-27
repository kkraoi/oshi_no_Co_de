class Report < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :reason, presence: true, on: :public
  validates :admin_feedback, presence: true, on: :admin
end
