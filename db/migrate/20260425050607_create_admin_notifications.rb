class CreateAdminNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_notifications do |t|
      t.integer :kind

      t.string :email_from
      t.text :message

      t.integer :comment_id

      t.boolean :new_rec
      t.timestamps
    end
  end
end
