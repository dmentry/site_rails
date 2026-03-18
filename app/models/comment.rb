class Comment < ApplicationRecord
  attr_accessor :current_user

  belongs_to :article

  has_many :replies, class_name: "Comment", foreign_key: "opinion_id", dependent: :destroy
  belongs_to :opinion, class_name: "Comment", foreign_key: "opinion_id", optional: true

  validates :comment_body, presence: true
  validates :comment_email, presence: true, if: :anonymous?

  validates :comment_email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :anonymous?

  validates_length_of :comment_body, maximum: 500

  private
  
  def anonymous?
    current_user.blank?
  end
end
