class AddForeignKeyToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :photos, :types
  end
end
