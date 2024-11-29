Rails.application.routes.draw do
  devise_for :users
  root 'reports#index'
  resources :set_list_orders, only: [:create, :update, :destroy]
  resources :user_favorites, only: [:create, :destroy]
  resources :sections, only: [:create, :update, :destroy]
  resources :report_bodies, only: [:create, :update]
  resources :report_favorites, only: [:create, :destroy]
  resources :reports do
    resources :sections do
      resources :set_list_orders do
        member do
          patch :update_position
          get :edit
        end
      end
      patch 'update_song_order', on: :member
    end
    post 'create_new', on: :collection
    collection do
      get 'invitation'
    end  
    member do
      get 'add_song'
      post 'add_song'
    end
  end
  namespace :search do
    get 'suggest_artists'
    get 'suggest_tracks'
  end
  resources :songs, only: [:new, :create]
  resources :users
  namespace :user do
    resources :my_reports do
      member do
        patch :toggle_status
      end
    end
  end
  resources :concerts
  get 'search/index'
  get 'mypage', to: 'users#mypage', as: :mypage

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
