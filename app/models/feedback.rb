class Feedback
  include ActiveModel::Model

  attr_accessor :feedback_email, :feedback_body

  validates_presence_of :feedback_body

  validates :feedback_email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # validates_format_of :feedback_email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validates_length_of :feedback_body, maximum: 1000
end