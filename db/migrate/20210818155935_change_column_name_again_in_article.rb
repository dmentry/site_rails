class ChangeColumnNameAgainInArticle < ActiveRecord::Migration[6.0]
  def change
    rename_column :articles, :article_body, :article_body_ru
    
    rename_column :articles, :article_title, :article_title_ru
  end
end
