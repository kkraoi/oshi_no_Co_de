class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :name, presence: true
  validates :password_confirmation, presence: true

  has_one_attached :profile_image

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'default-profile_image.png'
  end
end
