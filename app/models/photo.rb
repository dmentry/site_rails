class Photo < ApplicationRecord
  translates :description

  PHOTOS_ON_PAGE = 12

  belongs_to :user
  belongs_to :type

  validates :photo, presence: true

  validates :lat, :long, format: { with: /\A([-+]?[0-9]{1,3})(\.[0-9]+)?\z/, message: 'Разряды должны быть разделены точкой' }, allow_blank: true

  scope :without_photohosting, -> { includes(:type).where.not(types: {photo_type: 'photohosting'}) }

  scope :photos_by_type, -> (id) { where("type_id = ?", id).order("created_at DESC") }

  # Добавляем uploader, чтобы заработал carrierwave
  mount_uploader :photo, PhotoUploader
end
