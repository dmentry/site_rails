class ChangeColumnNaneFromType < ActiveRecord::Migration[6.0]
  def change
    rename_column :types, :type, :photo_type
  end
end
