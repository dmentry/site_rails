module SendMailService
  def self.call(send_email_to_comment:, article_full_link:, comment:, locale:)
    comment_to_send_email = Comment.where(id: send_email_to_comment).first

    return if !comment_to_send_email.present?

    email_to = comment_to_send_email.comment_email

    return if !email_to.present?

    header = if locale == 'ru'
               'Ответ на ваш комментарий на фотосайте dack9.ru'
             else
               'Your comment at photosite dack9.ru was answered'
             end

    begin
      FeedbackMailer.visitor_comment_answer(email_to: email_to, article_link: article_full_link, comment: comment, header: header).deliver_now
    rescue => e
      # Логируем ошибку, но не ломаем пользовательский опыт
      Rails.logger.error "Ошибка отправки мейла - ответа на коммент: #{ e.message }"
    end
  end
end
