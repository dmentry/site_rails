class Photo < ApplicationRecord
  include Hashtaggable

  before_save :split_coordinates

  attr_accessor :one_string_coordinates

  enum kind: { macro: 1, landscape: 2, portrait: 3, drone: 4, collage: 5, other: 6, photohosting: 7 }

  translates :description, :body

  PHOTOS_ON_PAGE = 10

  belongs_to :user

  validates :photo, :kind, presence: true

  validates :lat, :long, format: { with: /\A([-+]?[0-9]{1,3})(\.[0-9]+)?\z/, message: 'Разряды должны быть разделены точкой' }, allow_blank: true

  scope :without_photohosting, -> { where.not(kind: :photohosting) }

  # Добавляем uploader, чтобы заработал carrierwave
  mount_uploader :photo, PhotoUploader

  def human_kind
    I18n.t("enums.photo.kind.#{ kind }", default: kind.to_s.humanize)
  end

  def self.kind_options
    kinds.keys.map do |kind|
      [I18n.t("enums.photo.kind.#{ kind }", default: kind.to_s.humanize), kind]
    end
  end

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
