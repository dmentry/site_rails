class AddIndexToPhotoTipeIdFromPhoto < ActiveRecord::Migration[6.0]
  def change
    add_index :photos, :photo_type_id
  end
end
