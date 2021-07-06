class Article < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :article_title, :article_body, presence: true
  validates :article_body, presence: true
end
