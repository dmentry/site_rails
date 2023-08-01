module LastSeenVisitorsHelper
  def not_seen_visitors_class(last_seen_visitors_ids: nil, visitor:)
    return 'table-success' if last_seen_visitors_ids.present? && @last_seen_visitors_ids.include?(visitor.id)

    return ''
  end
end
