Rails.application.routes.draw do
    
    
    devise_for :users, skip: [:registrations, :sessions, :passwords]

    devise_scope :user do
        # session
        get 'login',                        to: 'users/sessions#new',           as: 'new_user_session'
        post 'login',                       to: 'users/sessions#create',        as: 'user_session'
        delete 'logout',                    to: 'users/sessions#destroy',       as: 'destroy_user_session'

        # passwords
        get 'password/new',                 to: 'users/passwords#new',          as: 'new_user_password'
        get 'password/edit',                to: 'users/password#edit',          as: 'edit_user_password'
        patch 'password',                   to: 'users/passwords#update',       as: 'user_password'
        post 'password',                    to: 'users/passwords#create'

        # registrations
        get ':role/register',               to: 'users/registrations#new',      as: 'new_user_registration'
        post ':role/register',              to: 'users/registrations#create',   as: 'user_registration'
        post ':role/register_daycare',      to: 'users/registrations#daycare',  as: 'daycare_registration'
    end

    # custom registration routes
    scope 'worker', controller: 'users/workers' do
        get :select_daycare, as: 'worker_select_daycare'
        get :select_department, as: 'worker_select_department'
    end

    root to: 'pages#home'

    %w( about mission path standard getting_started welcome infection instruction implementation ).each do |page|
        get page, to: "pages##{page}"
    end

    get 'dashboard', to: 'dashboard#index'

    get 'upgrade', to: 'subscriptions#index'
    resources :plans, only: [] do
      resources :subscriptions, only: [:new, :create] do
        get :complete, on: :member
      end
    end

    get 'complete', to: 'subscriptions#complete'

    namespace :manager do
        resources :todos do
            collection do
                get :dashboard
                get :search
            end
            member do
                get :set_date_range
                get :report
            end
        end
        resources :survey_subjects, as: 'subjects', path: 'subjects' do
            get :dashboard, on: :collection
            resources :surveys do
                resources :attempts, only: [:show, :index]
            end
        end
        resources :daycares, only: [] do
            collection do
                get :invite
                post :send_invites
            end
        end
    end

    resources :survey_subjects, as: 'subjects', path: 'subjects', only:[] do
        get :results, on: :member
        resources :attempts, only: [:new, :create]
    end

    resources :todos, only: [:index] do
        get :search, on: :collection
        resources :todo_completes, only: [:show, :create]
    end
    resources :todo_task_completes, only: :update

    resources :trainings, only: :show

    namespace :admin do
        root to: 'dashboard#index'
        authenticate :user, lambda { |u| u.admin? } do
            mount Sidekiq::Web => '/sidekiq'
        end
        resources :discount_codes, except: :show
        resources :plans, except: :show
        resources :todos
        resources :users, only: :index
        resources :daycares, only: :index
        resources :departments, only: :index 
    end

    namespace :api, constraints: { format: 'json' } do
        resources :daycares, only: [:index] do
            resources :departments, only: :index
        end
    end
end
