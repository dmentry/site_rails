class AddColumnsToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :lat, :text, limit: 50
    add_column :photos, :long, :text, limit: 50
  end
end
