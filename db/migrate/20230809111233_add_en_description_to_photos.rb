class AddEnDescriptionToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :description_ru, :string
    add_column :photos, :description_en, :string

    Photo.reset_column_information

    Photo.update_all('description_ru = description')

    remove_column :photos, :description 
  end
end
