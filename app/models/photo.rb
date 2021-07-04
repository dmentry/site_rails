class Photo < ApplicationRecord
  belongs_to :user

  validates :photo, presence: true

  # Добавляем uploader, чтобы заработал carrierwave
  mount_uploader :photo, PhotoUploader
end
