class AddMoreColumnsToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :announce_ru, :text
    add_column :articles, :announce_en, :text
    add_column :articles, :text_color, :string
    add_column :articles, :background_color, :string
  end
end
