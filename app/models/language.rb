class Language < ApplicationRecord
  # :restrict_with_exception => 管理者が言語を消した時、それに連鎖してcodesまで消えるとまずい。例外を投げて止める。
  has_many :codes, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :extension, presence: true
  validates :color, presence: true
end
