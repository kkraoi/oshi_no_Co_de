class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members
  
  validates :name, presence: true
  validates :password_confirmation, presence: true, if: -> { password.present? }
  validates :github,
  format: {
    # \Ahttps: => 文字の先頭はhttps:から始まる
    # [a-zA-Z0-9\-]+\z => アルファベットと数字と「-」から成る文字列で末尾が終わる
    with: /\Ahttps:\/\/github\.com\/[a-zA-Z0-9\-]+\z/,
    message: "は https://github.com/ に続くユーザー名を入力してください"
  },
  allow_blank: true

  has_one_attached :profile_image

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'default-profile_image.png'
  end
end
