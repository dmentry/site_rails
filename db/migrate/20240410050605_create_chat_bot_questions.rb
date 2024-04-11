class CreateChatBotQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_bot_questions do |t|
      t.text :body_ru
      t.text :body_en
      t.integer :order
      t.string :next_id

      t.timestamps

      t.references :chat_bot_topic
    end
  end
end
