class Article < ApplicationRecord
  ARTICLES_ON_PAGE = 2

  translates :article_title, :article_body

  has_many :comments, dependent: :destroy

  validates :article_title, :article_body, presence: true
  validates :article_body, presence: true
end
