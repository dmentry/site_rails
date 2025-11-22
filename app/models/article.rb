class Article < ApplicationRecord
  ARTICLES_ON_PAGE = 5

  include Hashtaggable

  translates :article_title, :article_body, :announce

  has_many :comments, dependent: :destroy

  validates :article_title, :article_body, :announce, presence: true
  validates :article_body, presence: true
end
