class ChangeColumnNameInComment < ActiveRecord::Migration[6.0]
  def change
    rename_column :comments, :type, :comment_body
  end
end
