class Photo < ApplicationRecord
  belongs_to :user
  belongs_to :type

  validates :photo, presence: true

  scope :without_photohosting, -> { includes(:type).where.not(types: {photo_type: 'photohosting'}) }

  scope :photos_by_type, -> (id) { where("type_id = ?", id).order("created_at DESC") }

  # Добавляем uploader, чтобы заработал carrierwave
  mount_uploader :photo, PhotoUploader
end
