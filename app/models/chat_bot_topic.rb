class ChatBotTopic < ActiveRecord::Base
  translates :label

  has_many :chat_bot_questions, dependent: :destroy

  validates :label, presence: true
  validates :show_order, uniqueness: true

  scope :visible_topics, -> { where.not(show_order: [false, nil]) }
end
