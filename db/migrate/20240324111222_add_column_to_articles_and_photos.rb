class AddColumnToArticlesAndPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :new_rec, :boolean, default: false
    add_column :photos,   :new_rec, :boolean, default: false
  end
end
