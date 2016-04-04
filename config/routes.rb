Rails.application.routes.draw do
    
    
    devise_for :users, skip: [:registrations, :sessions]

    devise_scope :user do
        # session
        get 'login',                to: 'users/sessions#new',           as: 'new_user_session'
        post 'login',               to: 'users/sessions#create',        as: 'user_session'
        delete 'logout',            to: 'users/sessions#destroy',       as: 'destroy_user_session'

        # registrations
        get ':role/register',            to: 'users/registrations#new',      as: 'new_user_registration'
        post 'register',           to: 'users/registrations#create',   as: 'user_registration'
    end

    root to: 'pages#home'

    %w( about mission path standard getting_started ).each do |page|
        get page, to: "pages##{page}"
    end

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

    resources :todos, only: [] do
        resources :todo_completes, only: [:show, :create]
    end
    resources :todo_task_completes, only: :update

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
