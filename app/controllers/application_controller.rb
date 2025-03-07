class ApplicationController < ActionController::Base
  # Все форматы, на которые могут отвечать экшены
  respond_to :html, :json

  # переключение локалей
  before_action :switch_locale

  # передача параметра текущей локали через запросы
  def default_url_options
    { locale: I18n.locale }
  end

  # Позволяем использовать возможности пандита во всех контроллерах
  include Pundit

  include Pagy::Backend

  # Настройка для работы Девайза, когда юзер правит профиль
  # before_action :configure_permitted_parameters, if: :devise_controller?

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(
  #     :account_update,
  #     keys: [:password, :password_confirmation, :current_password]
  #   )
  # end

  def photos_by_type(type)
    pagy(Photo.photos_by_type(type), items: Photo::PHOTOS_ON_PAGE)
  end

  def photos_header(type)
    photo_type = Type.find(type).photo_type

    t("controllers.photos.type.#{photo_type}")
  end

  # Обработать ошибку авторизации
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    # Перенаправляем юзера откуда пришел (или в корень сайта) с сообщением об ошибке
    flash[:alert] = 'Только для админа!'

    redirect_to(request.referrer || root_path)
  end

  private

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.locale = locale
  end
end
