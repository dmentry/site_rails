# app/models/hashtag.rb
class Hashtag < ApplicationRecord
  has_many :entity_hashtags, dependent: :destroy
  has_many :entities, through: :entity_hashtags

  validates :name, 
            presence: true, 
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 50 },
            format: { with: /\A[\p{Word}]+\z/, message: "can only contain letters, numbers and underscores" }

  before_validation :normalize_name

  def self.search(query)
    where("name ILIKE ?", "%#{sanitize_sql_like(query)}%").limit(10)
  end

  def to_s
    "##{name}"
  end

  private

  def normalize_name
    return if name.blank?
    self.name = name.gsub(/[^\p{Word}]/, '').downcase
  end
end
