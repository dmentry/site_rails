module AdminNotificationsHelper
  def not_seen_notifications_class(notification:)
    return 'table-success' if notification.new_rec?

    ''
  end

  def notification_badge(kind:)
    case kind
    when 'message'
      'primary'
    when 'comment'
      'info'
    when 'comment_answer'
      'secondary'
    end
  end

  def new_notifications_class
    new_notifications ||= AdminNotification.where(new_rec: true).size

    if new_notifications > 0
      'text-primary font-weight-bold'
    else
      'text-secondary'
    end
  end

  def new_notifications_bkg_class(notification:)
    return 'green_bkg' if notification.new_rec?

    'bg-light'
  end
end
