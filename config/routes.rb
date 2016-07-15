Rails.application.routes.draw do

  resources :message_subjects
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
        post ':role/register_affiliate',    to: 'users/registrations#affiliate',as: 'affiliate_registration'
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
      resources :subscriptions, only: [:new, :create, :index] do
        get :complete, on: :member
      end
    end

    namespace :manager do
        resources :todos, except: [:new, :create] do
            collection do
                get :dashboard
                get :search
            end
        end

        namespace :reports do
            namespace :todos do
                root action: 'index'
                get :search
            end
            resources :todos, only: [] do
                get :set_date_range
                get :show
            end
        end


        resources :survey_subjects, as: 'subjects', path: 'subjects', only: [] do
            get :results
            get :user_result
            get :group_result
        end
        resources :daycares, only: [] do
            collection do
                get :invite
                post :send_invites
            end
        end

        resources :messages do
          collection do
            get  :select_department
            post :recipient
            post :subject
            post :sub_subject
            post :content
          end
        end
    end

    resources :survey_subjects, as: 'subjects', path: 'subjects', only:[] do
        get :results, on: :member
        resources :attempts, only: :new
        resources :surveys, only: [] do
            resources :attempts, only: :create
        end
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
        resources :subjects, except: :show
        resources :message_templates do
          collection do
            get  :subject
            post :sub_subject
            post :recipient
            post :content
            get  :edit_filters
            post :filter
          end
        end
        resources :messages, only: [:new, :create]

        resources :survey_subjects do
            match :upload, on: :member, via: [:get, :post]
            resources :surveys
        end
    end

    namespace :partner do
      resources :messages, only: [:index, :new, :create]
    end

    resources :messages, only: [] do
      get  :sub_subjects, on: :collection
    end

    namespace :api, constraints: { format: 'json' } do
      resources :daycares, only: [:index] do
        get :featured_daycare, on: :collection
        get :by_plan, on: :collection
        resources :departments, only: :index
      end
      resources :plans, only: :show

      resources :message_templates do
        get :filter_by, on: :collection
      end
    end

    get 'cast_vote', to: 'votes#cast_vote'
    get ':role/messages/:list_type/list', to: 'messages#list', as: 'list_messages'
end
