class ChangeColumnNameFromPhoto < ActiveRecord::Migration[6.0]
  def change
    rename_column :photos, :type_id, :photo_type_id
  end
end
