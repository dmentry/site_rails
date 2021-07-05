class ApplicationController < ActionController::Base
  # Настройка для работы Девайза, когда юзер правит профиль
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:password, :password_confirmation, :current_password]
    )
  end

  def photo_types_arr(type)
    photos = Photo.photos_by_type(type)

    header = Type.find(type).photo_type

    return photos, header
  end
end
