Rails.application.routes.draw do
  resources :discount_codes
  devise_for :users
end
