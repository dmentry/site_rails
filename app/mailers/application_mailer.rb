class ApplicationMailer < ActionMailer::Base
  default from: 'robot_feedback@edu.dack9.ru'

  EMAIL_TO = 'lorien97@mail.ru'

  layout 'mailer'
end
