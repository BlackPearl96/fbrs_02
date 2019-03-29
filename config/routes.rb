Rails.application.routes.draw do
  root "books#index"
  devise_for :users

  get "books/show", to: "books#show"
  get "books/find", to: "books#find"
  get "sessions/new"
  get "users/new"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "password_resets/new"
  get "password_resets/edit"
  delete "/logout", to: "sessions#destroy"

  resources :books do
    resources :reviews do
      resources :comments
    end
  end
  resources :users do
    member do
      get :following, :followers
    end
  end

  post "/like", to: "likes#create"
  delete "/unlike", to: "likes#destroy"
  delete "/unreview", to: "reviews#destroy"
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :relationships, only: [:create, :destroy]
  resources :suggests

  namespace :admin do
    root "static_pages#index"
    resources :books, except: :show
    resources :categories, except: [:edit, :update, :show]
    resources :users, only: [:index, :destroy]
  end
end
