class Feedback
  include ActiveModel::Model

  attr_accessor :feedback_email, :feedback_body

  validates_presence_of :feedback_body

  validates_format_of :feedback_email,:with => Devise::email_regexp

  validates_length_of :feedback_body, :maximum => 500
end