module ApplicationHelper
  include Pagy::Frontend

  def flash_class(level)
    case level
    when "notice" then "alert alert-success"
    when "alert" then "alert alert-danger"
    end
  end

  def new_uniq_visitors
    last_visited_dt = LastSeenVisitor&.last&.last_seen_visitors_dt

    new_uniq_visitors ||= Visitor.where('uniq_visitor=? AND created_at>?', true, last_visited_dt).size

    if new_uniq_visitors > 0
      ['circle_badge_visible', new_uniq_visitors]
    else
      ['circle_badge_no', '']
    end
  end
end
