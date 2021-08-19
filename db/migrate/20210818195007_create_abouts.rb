class CreateAbouts < ActiveRecord::Migration[6.0]
  def change
    create_table :abouts do |t|
      t.text :main_text_ru

      t.text :main_text_en

      t.timestamps
    end
  end
end
