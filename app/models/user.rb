class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :likes, dependent: :destroy

  # フォローしているユーザーの関連
  has_many :active_relationships, class_name: "Relationship", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  # フォローされているユーザーの関連
  has_many :passive_relationships, class_name: "Relationship", dependent: :destroy
  has_many :follower, through: :passive_relationships, source: :follower
  
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

  def get_profile_image(width = 100, height = 100)
    if profile_image.attached?
      profile_image.variant(resize_to_limit: [width, height])
    else
      file_path = Rails.root.join("app/assets/images/default-profile_image.webp")
      default_blob = ActiveStorage::Blob.find_by(filename: "default-profile_image.webp") || ActiveStorage::Blob.create_after_upload!(
        io: File.open(file_path),
        filename: "default-profile_image.webp",
        content_type: "image/webp"
      )
      default_blob.variant(resize_to_limit: [width, height])
    end
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

  # ゲストユーザー判定
  def guest?
    email == GUEST_USER_EMAIL
  end

  # 引数のユーザーをフォローする
  #
  # @param param_name [User] フォローするユーザー
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  # 引数のユーザーをフォロー解除する
  #
  # @param param_name [User] 解除するユーザー
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  # 引数のユーザーをフォローしているか
  #
  # @param param_name [User] 解除するユーザー
  def following?(user)
    followings.include?(user)
  end
end
