Rails.application.routes.draw do
  devise_for :users

  # resources :users, except: [:create, :delete]
  resources :users, only: [:show, :edit, :update]
  resources :photos

  root 'photos#index'
end
