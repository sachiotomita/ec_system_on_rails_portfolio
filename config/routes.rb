Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Letter opener web for email preview in development
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  
  # Service worker route
  get "serviceworker.js" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Devise routes
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # Store routes (ストアフロント) - トップレベル
  root 'home#index'
  
  resources :products, only: [:index, :show] do
    member do
      post :add_to_cart
    end
  end

  get 'cart', to: 'cart#show'
  get 'cart/count', to: 'cart#count'
  post 'cart/add_item', to: 'cart#add_item'
  patch 'cart/update_item', to: 'cart#update_item'
  delete 'cart/remove_item', to: 'cart#remove_item'
  delete 'cart/clear', to: 'cart#clear'

  resources :orders, only: [:index, :show, :new, :create] do
    member do
      patch :cancel
    end
  end

  # Admin routes (管理画面) - namespace使用
  namespace :admin do
    root 'dashboard#index'
    
    resources :products
    resources :categories
    resources :orders, only: [:index, :show, :update]
  end
end
