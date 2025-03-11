class AddCountryEnToVisitors < ActiveRecord::Migration[6.0]
  def change
    add_column :visitors, :country_en, :string
  end
end
