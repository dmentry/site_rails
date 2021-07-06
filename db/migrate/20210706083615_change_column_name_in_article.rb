class ChangeColumnNameInArticle < ActiveRecord::Migration[6.0]
  def change
    rename_column :articles, :type, :article_body
  end
end
