class CreateVisitors < ActiveRecord::Migration[6.0]
  def change
    create_table :visitors do |t|
      t.datetime :time_visited
      t.string :timezone
      t.string :page_name
      t.string :referrer
      t.string :common_info
      t.string :platform
      t.string :os
      t.string :browser_language
      t.string :size_screen_w
      t.string :size_screen_h
      t.string :country
      t.string :region
      t.string :city
      t.string :u_id
      t.boolean :uniq_visitor, null: false, default: false, index: true

      t.timestamps
    end
  end
end
