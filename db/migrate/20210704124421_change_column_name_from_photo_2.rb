class ChangeColumnNameFromPhoto2 < ActiveRecord::Migration[6.0]
  def change
    rename_column :photos, :photo_type_id, :type_id
    add_index :photos, :type_id
  end
end
