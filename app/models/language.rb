class Language < ApplicationRecord
  validates :name, presence: true
  validates :extension, presence: true
  validates :color, presence: true
end
