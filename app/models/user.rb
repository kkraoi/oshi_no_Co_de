class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members
  has_many :comments, dependent: :destroy
  
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

  # 検索しても良いカラムを明示する
  # auth_object => 検索を実行しているユーザーの情報を入れる。
  # auth_object = nil => ログインしてない人でも検索可能になる。
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end
end
