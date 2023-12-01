Rails.application.routes.draw do

  # Настроить маршруты, чтобы URL с локалью выглядел так: /ru/articles, а не так: /articles/?locale=ru
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    devise_for :users, controllers: { registrations: 'users/registrations' }

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

    get 'map' => 'photos#map', as: :map
    get 'ym_balloon_data' => 'photos#ym_balloon_data', defaults: { format: :json }

    get 'get_data' => 'analytics#get_data', as: :get_data
    get 'show_visitors_info' => 'analytics#show_visitors_info', as: :show_visitors_info
    get 'show_visitor_info' => 'analytics#show_visitor_info', as: :show_visitor_info
    get 'show_visits' => 'analytics#show_visits', as: :show_visits
    get 'are_new_visitors' => 'analytics#are_new_visitors', as: :are_new_visitors, defaults: { format: :json }

    get 'comments/answer_comment_new/:comment_id' => 'comments#answer_comment_new', as: :answer_comment_new
    post 'comments/answer_comment_new/:comment_id' => 'comments#create_answer_comment', as: :create_answer_comment

    root to: 'photos#index'
  end
end
