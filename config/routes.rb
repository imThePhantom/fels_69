Rails.application.routes.draw do

  root "static_pages#home"

  get "help" => "static_pages#help"

  get "about" => "static_pages#about"

  get "contact" => "static_pages#contact"

  get "signup" => "users#new"

  get "login" => "sessions#new"

  post "login" => "sessions#create"

  delete "logout" => "sessions#destroy"

  resources :users

  resources :words, only: [:index]

  resources :categories do
    resources :lessons
  end

  namespace :admin do
    resources :users
    resources :categories do
      resources :words
    end
    resources :words
  end

  resources :relationships,  only: [:create, :destroy, :index]
  get "/users/:id/:type" => "relationships#index"
end
