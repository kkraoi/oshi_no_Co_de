class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  validates :name, presence: true
  validates :password_confirmation, presence: true, if: -> { 
    # パスワードが存在している場合、ゲストグインは除く
    password.present? && !guest?
  }
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

  GUEST_USER_EMAIL = "guest@example.com"

  # Userモデルで使用できるメソッドとしてUser.guestの記述が可能になる
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      # ランダムな文字列を生成するRubyのメソッドの一種
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  def guest?
    email == GUEST_USER_EMAIL
  end
end
