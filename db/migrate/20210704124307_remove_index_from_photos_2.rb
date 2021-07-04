class RemoveIndexFromPhotos2 < ActiveRecord::Migration[6.0]
  def change
    remove_index :photos, :photo_type_id
  end
end
