class AddIpToVisitors < ActiveRecord::Migration[6.0]
  def change
    add_column :visitors, :ip, :string
  end
end
