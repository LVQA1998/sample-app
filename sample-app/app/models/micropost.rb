class Micropost < ApplicationRecord
  MICROPOST_PARAMS = [:content, :image]
  belongs_to :user
  has_one_attached :image
  
  scope :by_created_at, -> {order created_at: :desc}
  scope :feed_by_following, -> (following_ids) {where user_id: following_ids}

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.content_max}
  validates :image, content_type: {in: Settings.image.extension_whitelist, message: I18n.t("microposts.image_format")}, size: {less_than: Settings.image.size.megabytes, message: I18n.t("microposts.image_size", size: Settings.image.size)}
  
  def print_image
    image.variant resize_to_limit: Settings.image.resize
  end
end
