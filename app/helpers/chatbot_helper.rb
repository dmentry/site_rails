module ChatbotHelper
  def show_chatbot
    ChatBotTopic.visible_topics.size > 0
  end
end
