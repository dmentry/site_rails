class ChatBotTopic < ActiveRecord::Base
  translates :label

  has_many :chat_bot_questions, dependent: :destroy

  validates :label, presence: true

  scope :visible_topics, -> { where(is_shown: true) }
end
