class Hashtag < ApplicationRecord
  has_many :entity_hashtags, dependent: :destroy
  has_many :entities, through: :entity_hashtags

  validates :name, 
            presence: true, 
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 50 },
            format: { with: /\A[a-zA-Z0-9_а-яА-ЯЁё\s]+\z/, message: "может содержать только буквы, цифры и подчеркивание" }

  before_save :normalize_name

  def self.search(query)
    where("name ILIKE ?", "%#{sanitize_sql_like(query)}%").limit(10)
  end

  def to_s
    "##{name}"
  end

  private

  def normalize_name
    return if name.blank?

    self.name = name.gsub(/[^\p{Word}]/, '_').downcase
  end
end
