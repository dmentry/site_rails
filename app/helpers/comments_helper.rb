module CommentsHelper
def sort_comments(comments:, answers:)
  comments = comments.to_a
  answers = answers.to_a

  comments_w_replies = []

  sorted_replies = recursive_sort(answers)

  sorted_replies_tmp = sorted_replies.map(&:clone)

  comments.each do |comment|
    comments_w_replies << comment

    sorted_replies.each do |reply|
      if comment.id == reply.opinion_id
        comments_w_replies << reply

        next
      end
    end
  end

  comments_w_replies + (sorted_replies_tmp - comments_w_replies)

  end

  private

  def recursive_sort(arr)
    return arr if arr.length <= 1

    pivot = arr.shift
    left, right = arr.partition { |el| el.opinion_id < pivot.opinion_id || (el.opinion_id == pivot.opinion_id && el.id < pivot.id) }

    recursive_sort(left) + [pivot] + recursive_sort(right)
  end
end
