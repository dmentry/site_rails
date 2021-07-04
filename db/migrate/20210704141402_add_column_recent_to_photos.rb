class AddColumnRecentToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :recent, :boolean
  end
end
