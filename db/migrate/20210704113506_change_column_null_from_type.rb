class ChangeColumnNullFromType < ActiveRecord::Migration[6.0]
  def change
    change_column_null :types, :type, false
  end
end
