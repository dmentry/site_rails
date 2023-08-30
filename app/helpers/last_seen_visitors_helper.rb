module LastSeenVisitorsHelper
  def not_seen_visitors_class(new_visitors_ids: nil, visitor:)
    return 'table-success' if new_visitors_ids && new_visitors_ids.include?(visitor.id)

    return ''
  end
end
