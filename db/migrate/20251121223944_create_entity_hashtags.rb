class CreateEntityHashtags < ActiveRecord::Migration[6.0]
  def change
    create_table :entity_hashtags do |t|
      t.references :entity, polymorphic: true, null: false
      t.references :hashtag, null: false, foreign_key: true
      t.timestamps
    end
    
    add_index :entity_hashtags, [:entity_type, :entity_id, :hashtag_id], unique: true, name: 'index_entity_hashtags_on_entity_and_hashtag'
  end
end
