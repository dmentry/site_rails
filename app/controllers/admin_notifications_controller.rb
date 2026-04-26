class AdminNotificationsController < ApplicationController
  before_action :set_notification, only: %i[show destroy]

  def index
    @nav_menu_active_item = 'admin_notifications'

    notifications = AdminNotification.all.order(created_at: :desc)

    authorize notifications

    @pagy, @notifications = pagy(notifications, items: 25)
  end

  def show
    authorize @notification

    @notification.update_column(:new_rec, false)
  end

  def destroy
    @notification.destroy

    redirect_to admin_notifications_path, notice: ('Уведомление удалено')
  end

  private

  def set_notification
    @notification = AdminNotification.find(params[:id])
  end
end
