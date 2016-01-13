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
  end
  
  namespace :admin do
    
    resources :sessions
    
    root 'dashboard#index'
    
    get 'clear_cache' => 'dashboard#clear_cache'
    get 'login' => 'sessions#new'
    get 'logout' => 'sessions#destroy'
    get 'password_reset' => 'system/users#password_reset'
    get 'users/random' => 'system/users#random'

    get 'search' => 'search#index'
    
    namespace :system do
      resources :users do
        member do
          get 'logins' => 'users#show'
          get 'login' => 'users#login'
          get 'welcome_email'
        end
      end
      resources :affiliates do
        member do
          get 'categories' => 'affiliates#categories'
          post 'categories' => 'affiliates#create_categories'
        end
      end

      resources :roles
      resources :settings
      resources :logins
      resources :notifications
      resources :categories
      resources :search_paths
      resources :attributes
      resources :domains do 
        member do 
          get 'set_current'
        end
      end
    end
    
  end
  
end
