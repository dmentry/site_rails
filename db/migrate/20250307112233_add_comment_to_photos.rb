class AddCommentToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :body_ru, :text
    add_column :photos, :body_en, :text
  end
end
