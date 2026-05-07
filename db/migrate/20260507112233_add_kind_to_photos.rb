class AddKindToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :kind, :integer

    Photo.reset_column_information

    Photo.update_all('kind = type_id')
  end
end
