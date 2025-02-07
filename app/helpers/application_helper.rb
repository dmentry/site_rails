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
      return ['circle_badge_visible_ru', new_uniq_visitors] if params[:locale] == 'ru' || params[:locale] == nil

      ['circle_badge_visible_eng', new_uniq_visitors]
    else
      ['circle_badge_no', false]
    end
  end

  def breadcrumbs(*crumbs)
    content_tag(:nav, aria: { label: 'breadcrumb' }) do
      content_tag(:ol, class: 'breadcrumb justify-content-center nav_font_size mb-5') do
        crumbs.each_with_index.map do |(label, path), index|
          if path
            content_tag(:li, link_to(label, path), class: 'breadcrumb-item')
          else
            content_tag(:li, label, class: 'breadcrumb-item active', 'aria-current': 'page')
          end
        end.join.html_safe
      end
    end
  end
end
