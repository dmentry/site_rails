class CreateChatBotTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_bot_topics do |t|
      t.string :label_ru
      t.string :label_en
      t.integer :show_order

      t.timestamps
    end
  end
end
