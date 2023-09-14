class Photo < ApplicationRecord
  before_save :split_coordinates

  attr_accessor :one_string_coordinates

  translates :description

  PHOTOS_ON_PAGE = 10

  belongs_to :user
  belongs_to :type

  validates :photo, presence: true

  validates :lat, :long, format: { with: /\A([-+]?[0-9]{1,3})(\.[0-9]+)?\z/, message: 'Разряды должны быть разделены точкой' }, allow_blank: true

  scope :without_photohosting, -> { includes(:type).where.not(types: {photo_type: 'photohosting'}) }

  scope :photos_by_type, -> (id) { where("type_id = ?", id).order("created_at DESC") }

  # Добавляем uploader, чтобы заработал carrierwave
  mount_uploader :photo, PhotoUploader

  private

  def split_coordinates
    return if !one_string_coordinates.present?

    lat  = '55.748560'
    long = '37.618766'

    out  = '55.765849, 38.116946'.match(/(\-?\d+\.\d+),\s(\-?\d+\.\d+)/)
    lat  = out[1]
    long = out[2]

    self.lat = lat
    self.long = long
  end
end
