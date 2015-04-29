Rails.application.routes.draw do
  devise_for :admins, :skip => [:registrations]
    as :admin do
      get 'admins/edit' => 'devise/registrations#edit', :as => 'edit_admin_registration'
      patch 'admins/:id' => 'devise/registrations#update', :as => 'admin_registration'
    end

  get 'static/about'

  resources :way_points

  resources :track_points

  resources :tracks

  root 'home#index'

  mount NewRelicPing::Engine => '/status'
end
