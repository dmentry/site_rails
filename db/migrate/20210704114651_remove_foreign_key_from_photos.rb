class RemoveForeignKeyFromPhotos < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :photos, :types
  end
end
