class AddColumnToComment < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :comment_email, :text
  end
end
