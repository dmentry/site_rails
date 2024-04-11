class ChatBotQuestion < ActiveRecord::Base
  translates :body

  belongs_to :chat_bot_topic

  validates :body, :order, presence: true
  validates :order, uniqueness: { scope: :chat_bot_topic, case_sensitive: false, message: 'Такой номер реплики уже есть!' }
end
