class AddColumnToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :article_title, :text
  end
end
