class AddVisibleToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :is_visible, :boolean, default: false
  end
end
