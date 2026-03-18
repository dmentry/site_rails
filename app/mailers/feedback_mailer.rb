class FeedbackMailer < ApplicationMailer
  def feedback_message(feedback)
    @email_from = feedback.feedback_email

    @feedback_body = feedback.feedback_body

    mail(to: EMAIL_TO, subject: "Новое сообщение с фотосайта")
  end

  def visitor_comment_answer(email_to:, article_link:, comment:, header:)
    @article_link = article_link
    @comment      = comment

    mail(to: email_to, subject: header)
  end
end
