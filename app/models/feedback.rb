class Feedback
  include ActiveModel::Model

  attr_accessor :feedback_email, :feedback_body

  validates_presence_of :feedback_body

  # validates :feedback_email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_length_of :feedback_body, maximum: 1000
end