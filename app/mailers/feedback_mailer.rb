class FeedbackMailer < ApplicationMailer
  def feedback_message(feedback)
    @email_from = feedback.feedback_email

    @feedback_body = feedback.feedback_body

    mail(to: EMAIL_TO, subject: "Новое сообщение с фотосайта")
  end
end
