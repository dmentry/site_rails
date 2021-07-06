class Comment < ApplicationRecord
  belongs_to :article

  validates :comment_body, presence: true
end
