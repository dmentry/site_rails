class AddSelfConnectionToComments < ActiveRecord::Migration[6.0]
  def change
    change_table :comments do |t|
      t.references :opinion, foreign_key: { to_table: :comments }
    end
  end
end
