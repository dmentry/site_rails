module SendMailService
  def self.call(send_email_to_comment:, article_full_link:, comment:, locale:, admin_mail:, sent_mail_to_admin:)
    if sent_mail_to_admin
      begin
        FeedbackMailer.new_comment(email_to: admin_mail, article_link: article_full_link, comment: comment).deliver_now
      rescue => e
        # Логируем ошибку, но не ломаем пользовательский опыт
        Rails.logger.error "Ошибка отправки мейла - новый коммент (для админа): #{ e.message }"
      end
    end

    return if !send_email_to_comment.present?

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
      Rails.logger.error "Ошибка отправки мейла - про ответ на коммент: #{ e.message }"
    end
  end
end
