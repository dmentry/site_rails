class RemoveRecentFromPhotos < ActiveRecord::Migration[6.0]
  def change
    remove_column(:photos, :recent)
  end
end
