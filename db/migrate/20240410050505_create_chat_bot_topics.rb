class CreateChatBotTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_bot_topics do |t|
      t.string :label_ru
      t.string :label_en
      t.boolean :is_shown, default: false

      t.timestamps
    end
  end
end
