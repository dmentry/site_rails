class ApplicationController < ActionController::Base
  # Позволяем использовать возможности пандита во всех контроллерах
  include Pundit
  # Настройка для работы Девайза, когда юзер правит профиль
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:password, :password_confirmation, :current_password]
    )
  end

  def photos_and_type(type)
    photos = Photo.photos_by_type(type)

    header = Type.find(type).photo_type

    return photos, header
  end

  # Обработать ошибку авторизации
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    # Перенаправляем юзера откуда пришел (или в корень сайта) с сообщением об ошибке
    flash[:alert] = 'Только для админа!'

    redirect_to(request.referrer || root_path)
  end
end
