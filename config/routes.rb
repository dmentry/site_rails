Rails.application.routes.draw do
  # Настроить маршруты, чтобы URL с локалью выглядел так: /ru/articles, а не так: /articles/?locale=ru
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    devise_for :users, controllers: { registrations: 'users/registrations' }

    resources :users, only: [:show, :edit, :update]
    resources :photos
    resources :types
    resources :abouts
    resources :articles do
      resources :comments
    end

    resources :chat_bot_topics do
      resources :chat_bot_questions, except: [:show] 
    end

    get 'all_page' => 'photos#all_page', as: :all_page
    get 'macro_page' => 'photos#macro_page', as: :macro_page
    get 'landscape_page' => 'photos#landscape_page', as: :landscape_page
    get 'portrait_page' => 'photos#portrait_page', as: :portrait_page
    get 'drone_page' => 'photos#drone_page', as: :drone_page
    get 'collage_page' => 'photos#collage_page', as: :collage_page
    get 'other_page' => 'photos#other_page', as: :other_page
    get 'photohosting_page' => 'photos#photohosting_page', as: :photohosting_page

    get 'map' => 'photos#map', as: :map

    get 'get_data' => 'analytics#get_data', as: :get_data
    get 'show_visitors_info' => 'analytics#show_visitors_info', as: :show_visitors_info
    get 'show_visitor_info' => 'analytics#show_visitor_info', as: :show_visitor_info
    get 'show_visits' => 'analytics#show_visits', as: :show_visits
    get 'are_new_visitors' => 'analytics#are_new_visitors', as: :are_new_visitors, defaults: { format: :json }
    get 'map_countries' => 'analytics#map_countries', as: :map_countries

    get 'comments/answer_comment_new/:comment_id' => 'comments#answer_comment_new', as: :answer_comment_new
    post 'comments/answer_comment_new/:comment_id' => 'comments#create_answer_comment', as: :create_answer_comment

    get 'dack9_rss', to: 'home#rss_feed', defaults: { format: :rss }
    get 'sitemap.xml' => 'home#sitemap', format: "xml"
    get 'announces' => 'home#announces', as: :announces
    get 'searching', to: 'home#searching'
    get 'feedback_page' => 'home#feedback_page', as: :feedback_page
    post 'feedback_page_send' => 'home#feedback_page_send', as: :feedback_page_send

    get 'chat_bot' => 'chat_bot_topics#have_answer', as: :have_answer, defaults: { format: :json }

    # Принудительно установить локали для путей:
    get 'cv_rus' => 'abouts#cv_rus', as: :cv_rus, defaults: { locale: :ru }
    get 'cv_eng' => 'abouts#cv_eng', as: :cv_eng, defaults: { locale: :en }

    get 'portfolio', to: 'abouts#portfolio'
    get 'portfolio_case', to: 'abouts#portfolio_case'

    root to: 'home#announces'
  end
end
