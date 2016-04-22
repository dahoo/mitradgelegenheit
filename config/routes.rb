Rails.application.routes.draw do
  resources :comments, only: [:create, :edit, :update, :destroy]

  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :users, only: [:index, :show]

  get 'static/about'

  resources :way_points

  resources :track_points

  resources :tracks

  root 'home#index'
end
