class AddCoordinatesToVisitors < ActiveRecord::Migration[6.0]
  def change
    add_column :visitors, :city_lat, :string
    add_column :visitors, :city_long, :string
  end
end
