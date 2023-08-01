class CreateLastSeenVisitors < ActiveRecord::Migration[6.0]
  def change
    create_table :last_seen_visitors do |t|
      t.datetime :last_seen_visitors_dt

      t.timestamps
    end
  end
end
