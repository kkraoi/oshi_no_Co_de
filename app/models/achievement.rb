class Achievement < ApplicationRecord
  belongs_to :user

  has_one_attached :thumb

  def get_thumb_image(width = 300, height = 200)
    if thumb.attached?
      thumb.variant(resize_to_limit: [width, height])
    else
      file_path = Rails.root.join("app/assets/images/no_image.webp")
      default_blob = ActiveStorage::Blob.find_by(filename: "no_image.webp") || ActiveStorage::Blob.create_after_upload!(
        io: File.open(file_path),
        filename: "default-thumb_image.webp",
        content_type: "image/webp"
      )
      default_blob.variant(resize_to_limit: [width, height])
    end
  end
end
