# Настройки гема recaptcha
Recaptcha.configure do |config|
  config.site_key  = Rails.application.credentials.dig(Rails.env.to_sym, :recaptcha, :public_key)
  config.secret_key = Rails.application.credentials.dig(Rails.env.to_sym, :recaptcha, :private_key)
end