class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :name, presence: true
  validates :password_confirmation, presence: true

  has_one_attached :profile_image

  # 画像をリサイズしてwebp形式で返す。画像が添付されていなければ、デフォルト画像をWebPに変換して返す。
  #
  # ImageMagick または libvips + image_processing のインストールが必要。
  # @param width [Integer] 画像の幅
  # @param height [Integer] 画像の高さ
  # @return [ActiveStorage::Variant] WebP形式のリサイズ済み画像
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/default-profile_image.png')
      profile_image.attach(
        io: File.open(file_path),
        filename: 'default-image.jpg',
        content_type: 'image/jpeg'
      )
    end

    profile_image.variant(
      resize_to_limit: [width, height],
      format: :webp
    ).processed
  end
end
