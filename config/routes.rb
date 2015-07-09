Rails.application.routes.draw do
  devise_for :users

  get 'static/about'

  resources :way_points

  resources :track_points

  resources :tracks

  root 'home#index'

  mount NewRelicPing::Engine => '/status'
end
