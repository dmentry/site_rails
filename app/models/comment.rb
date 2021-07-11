class Comment < ApplicationRecord
  belongs_to :article

  validates :comment_body, presence: true
  validates :comment_email, presence: true

  validates :comment_email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_length_of :comment_body, maximum: 500
end
