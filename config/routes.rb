Rails.application.routes.draw do
    
    
    devise_for :users

    root to: 'pages#home'

    get 'dashboard', to: 'dashboard#index'

    get 'upgrade', to: 'subscriptions#index'
    resources :plans, only: [] do
      resources :subscriptions, only: [:new, :create] do
        get :complete, on: :member
      end
    end

    # get :action "pages##{:action}"

    namespace :admin do
        root to: 'dashboard#index'
        resources :discount_codes, except: :show
        resources :plans, except: :show
        resources :todos, except: :show
        resources :users, only: :index
        resources :daycares, only: :index
        resources :departments, only: :index 
    end
end
