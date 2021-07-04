class RemoveIndexFromPhotos < ActiveRecord::Migration[6.0]
  def change
    remove_index :photos, :type_id
  end
end
