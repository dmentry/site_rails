class CreateVisitors < ActiveRecord::Migration[6.0]
  def change
    create_table :visitors do |t|
      t.datetime :time_visited
      t.string :page_name
      t.string :referrer
      t.string :browser_name
      t.string :browser_platform
      t.string :size_screen_w
      t.string :size_screen_h
      t.string :country
      t.string :region_name
      t.string :lat
      t.string :lon
      t.string :timezone
      t.boolean :uniq_visitor, null: false, default: false, index: true

      t.timestamps
    end
  end
end
