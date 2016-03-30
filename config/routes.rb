Rails.application.routes.draw do
  resources :todos
  resources :discount_codes
  devise_for :users
end
