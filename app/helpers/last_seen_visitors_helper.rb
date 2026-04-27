module LastSeenVisitorsHelper
  def not_seen_visitors_class(new_visitors_ids: nil, visitor:)
    return 'table-success' if new_visitors_ids && new_visitors_ids.include?(visitor.id)

    return ''
  end

  def new_visitor_bkg_class(new_visitors_ids: nil, visitor:)
    return 'green_bkg' if new_visitors_ids && new_visitors_ids.include?(visitor.id)

    'bg-light'
  end
end
