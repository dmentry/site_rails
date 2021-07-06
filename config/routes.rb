Rails.application.routes.draw do
  devise_for :users

  # resources :users, except: [:create, :delete]
  resources :users, only: [:show, :edit, :update]
  resources :photos
  resources :types
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
  get 'about_page' => 'photos#about_page', as: :about_page
  get 'feedback_page' => 'photos#feedback_page', as: :feedback_page

  root 'photos#index'
end
