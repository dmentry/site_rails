class EntityHashtag < ApplicationRecord
  belongs_to :entity, polymorphic: true
  belongs_to :hashtag
  
  validates :hashtag_id, uniqueness: { scope: [:entity_type, :entity_id] }
end
