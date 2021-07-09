class FeedbackMailer < ApplicationMailer
  def feedback_message(feedback)
    @email = feedback.feedback_email

    @feedback_body = feedback.feedback_body

    mail to: @email, subject: "Новое сообщение с фотосайта"
  end
end
