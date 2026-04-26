class AdminNotification < ApplicationRecord
  enum kind: { message: 0, comment: 1, comment_answer: 2 }
end
