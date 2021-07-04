class AddForeignKeyToTypePhotoIdInPhotos < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :photos, :types, column: :photo_type_id, primary_key: "id"
  end
end
