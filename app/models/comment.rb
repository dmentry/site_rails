class Comment < ApplicationRecord
  belongs_to :article

  has_many :replies, class_name: "Comment", foreign_key: "opinion_id", dependent: :destroy
  belongs_to :opinion, class_name: "Comment", foreign_key: "opinion_id", optional: true

  validates :comment_body, presence: true
  validates :comment_email, presence: true

  validates :comment_email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_length_of :comment_body, maximum: 500
end
