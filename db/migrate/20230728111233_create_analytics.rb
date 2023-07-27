class CreateAnalytics < ActiveRecord::Migration[6.0]
  def change
    create_table :analytics do |t|
      t.integer :views_period_month
      t.integer :views_period_year
      t.integer :uniq_visitor, null: false, default: 0
      t.integer :repeat_visitor, null: false, default: 0

      t.timestamps
    end

    add_index :analytics, [:views_period_year, :views_period_month], name: "idx_analytics_time_period"
  end
end
