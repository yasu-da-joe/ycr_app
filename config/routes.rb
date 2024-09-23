Rails.application.routes.draw do
  resources :set_list_orders, only: [:create, :update, :destroy]
  resources :songs
  resources :user_favorites, only: [:create, :destroy]
  resources :sections, only: [:create, :update, :destroy]
  resources :report_bodies, only: [:create, :update]
  resources :report_favorites, only: [:create, :destroy]
  resources :reports
  resources :users
  resources :concerts
  get 'search/index'
  get 'login', to: 'user_sessions#new', as: :login
  post 'login', to: 'user_sessions#create'
  get 'mypage', to: 'users#mypage', as: :mypage
  delete 'logout', to: 'user_sessions#destroy', as: :logout

  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  get "search", to: "search#index"
  get "search/suggest_artists"
  get "search/suggest_tracks"
end
