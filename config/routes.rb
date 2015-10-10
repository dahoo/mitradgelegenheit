Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :users, only: [:index, :show]

  get 'static/about'

  resources :way_points

  resources :track_points

  resources :tracks

  root 'home#index'
end
