class AddColumnsToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :article_title_en, :text

    add_column :articles, :article_body_en, :text
  end
end
