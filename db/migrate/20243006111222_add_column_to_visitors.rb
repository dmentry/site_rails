class AddColumnToVisitors < ActiveRecord::Migration[6.0]
  def change
    add_column :visitors, :send_to_script, :boolean, default: false
  end
end
