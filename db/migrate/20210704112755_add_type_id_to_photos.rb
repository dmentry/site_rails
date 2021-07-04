class AddTypeIdToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :type_id, :bigint
    add_index :photos, :type_id
  end
end
