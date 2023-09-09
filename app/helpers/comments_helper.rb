module CommentsHelper
  class CommentSort
    def initialize
      @out = []
    end

    def sort_comments(comments, otstup)
      comments.each do |comment|
        @out << [comment, otstup]

        if comment.replies.present?
          sort_comments(comment.replies, otstup + 1)
        end
      end

      @out
    end
  end
end
