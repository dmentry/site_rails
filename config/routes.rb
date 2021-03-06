Rails.application.routes.draw do

  # Настроить маршруты, чтобы URL с локалью выглядел так: /ru/articles, а не так: /articles/?locale=ru
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    devise_for :users
    resources :users, only: [:show, :edit, :update]
    resources :photos
    resources :types
    resources :abouts
    resources :articles do
      # Вложенный ресурс комментов. Понадобится два экшена: create и destroy
      resources :comments, only: [:create, :destroy]
    end

    get 'all_page' => 'photos#all_page', as: :all_page
    get 'macro_page' => 'photos#macro_page', as: :macro_page
    get 'landscape_page' => 'photos#landscape_page', as: :landscape_page
    get 'portrait_page' => 'photos#portrait_page', as: :portrait_page
    get 'drone_page' => 'photos#drone_page', as: :drone_page
    get 'collage_page' => 'photos#collage_page', as: :collage_page
    get 'other_page' => 'photos#other_page', as: :other_page
    get 'photohosting_page' => 'photos#photohosting_page', as: :photohosting_page
    get 'feedback_page' => 'photos#feedback_page', as: :feedback_page
    post 'feedback_page_send' => 'photos#feedback_page_send', as: :feedback_page_send

    root to: 'photos#index'
  end
end
