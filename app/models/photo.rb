class Photo < ApplicationRecord
  belongs_to :user
  belongs_to :type

  validates :photo, presence: true

  # Добавляем uploader, чтобы заработал carrierwave
  mount_uploader :photo, PhotoUploader
end
