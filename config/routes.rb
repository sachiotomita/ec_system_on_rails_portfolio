Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Devise routes
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Root path
  root 'products#index'

  # Product routes
  resources :products do
    member do
      post :add_to_cart
    end
  end

  # Cart routes
  get 'cart', to: 'cart#show'
  post 'cart/add_item', to: 'cart#add_item'
  patch 'cart/update_item', to: 'cart#update_item'
  delete 'cart/remove_item', to: 'cart#remove_item'
  delete 'cart/clear', to: 'cart#clear'

  # Order routes
  resources :orders, only: [:index, :show, :new, :create] do
    member do
      patch :cancel
    end
  end

  # Admin routes
  namespace :admin do
    resources :products
    resources :categories
    resources :orders, only: [:index, :show, :update]
    root 'dashboard#index'
  end
end
