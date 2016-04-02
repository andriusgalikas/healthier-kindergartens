Rails.application.routes.draw do
    
    
    devise_for :users

    root to: 'pages#home'
    get :about, to: 'pages#about'
    get :mission, to: 'pages#mission'
    get :path, to: 'pages#path'
    get :standard, to: 'pages#standard'

    get 'dashboard', to: 'dashboard#index'

    get 'upgrade', to: 'subscriptions#index'
    resources :plans, only: [] do
      resources :subscriptions, only: [:new, :create] do
        get :complete, on: :member
      end
    end

    namespace :manager do
        resources :todos, except: :index
    end

    resources :todos

    namespace :admin do
        root to: 'dashboard#index'
        authenticate :user do
            mount Sidekiq::Web => '/sidekiq'
        end
        resources :discount_codes, except: :show
        resources :plans, except: :show
        resources :todos
        resources :users, only: :index
        resources :daycares, only: :index
        resources :departments, only: :index 
    end
end
