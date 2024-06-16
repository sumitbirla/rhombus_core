Rails.application.routes.draw do
  resources :sessions
  resources :users do 
    member do 
      get 'status'
    end
  end 

  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  get 'register' => 'users#new'
  get 'reset_password' => 'users#reset_password'
  post 'reset_password' => 'users#reset_password_email'
  get 'resetp/:id' => 'users#new_password'
  patch 'resetp' => 'users#update_password'
  post 'resetp' => 'users#update_password'

  get '/auth/failure', to: 'sessions#new'
  get '/auth/:provider/callback', to: 'sessions#create_omniauth'
  
  namespace :account do
    get 'profile/edit' => 'profile#edit'
    patch 'profile/edit' => 'profile#update'
    resources :affiliate
		resources :logs
    resources :webauthn_credentials
  end
  
  namespace :admin do
    resources :sessions
    post 'passkey_login' => 'sessions#passkey_login'
    
    root 'dashboard#index'
    get 'dashboard' => 'dashboard#index'
    get 'clear_cache' => 'dashboard#clear_cache'
    get 'login' => 'sessions#new'
    get 'logout' => 'sessions#destroy'
    get 'password_reset' => 'system/users#password_reset'
    get 'users/random' => 'system/users#random'
    get 'search' => 'search#index'

    namespace :system do
      post 'printers/print_url' => 'printers#print_url'
      resources :webauthn_credentials

      resources :users do
        member do
          get 'logins' => 'users#show'
          get 'login' => 'users#login'
          get 'extra_properties'
          get 'welcome_email'
        end
      end
      resources :affiliates do
        member do
          get 'extra_properties'
          get 'categories'
          post 'categories' => 'affiliates#create_categories'
        end
      end

      resources :roles
      resources :settings
      resources :logs
      resources :notifications
      resources :notification_subscriptions
      resources :events do
        member do
          get 'resend'
        end
      end
      resources :event_types
      resources :categories
      resources :search_paths
      resources :attributes
      resources :extra_properties
      resources :printers
      resources :domains do 
        member do 
          get 'set_current'
        end
      end
    end
  end
end
