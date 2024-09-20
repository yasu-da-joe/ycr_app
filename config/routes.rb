Rails.application.routes.draw do
  get "set_list_orders/create"
  get "set_list_orders/update"
  get "set_list_orders/destroy"
  get "songs/index"
  get "songs/show"
  get "songs/new"
  get "songs/create"
  get "songs/edit"
  get "songs/update"
  get "songs/destroy"
  get "user_favorites/create"
  get "user_favorites/destroy"
  get "sections/create"
  get "sections/update"
  get "sections/destroy"
  get "report_bodies/create"
  get "report_bodies/update"
  get "report_favorites/create"
  get "report_favorites/destroy"
  get "reports/index"
  get "reports/show"
  get "reports/new"
  get "reports/create"
  get "reports/edit"
  get "reports/update"
  get "reports/destroy"
  get "users/index"
  get "users/show"
  get "users/new"
  get "users/create"
  get "users/edit"
  get "users/update"
  get "users/destroy"
  get "concerts/index"
  get "concerts/show"
  get "concerts/new"
  get "concerts/create"
  get "concerts/edit"
  get "concerts/update"
  get "concerts/destroy"
  get "search/index"
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
