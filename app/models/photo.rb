class Photo < ApplicationRecord
  before_save :split_coordinates

  attr_accessor :one_string_coordinates

  translates :description, :body

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
    if !one_string_coordinates.present?
      self.lat = nil
      self.long = nil

      return
    end

    out  = one_string_coordinates.match(/(\-?\d+\.\d+),\s(\-?\d+\.\d+)/)
    lat  = out[1]
    long = out[2]

    self.lat = lat if lat.present?
    self.long = long if long.present?
  end
end
