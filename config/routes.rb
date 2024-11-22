Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  # ChatApp routes: =================================================================

  # Defines the custom route for getting a chat_app by application_token
  get "chat_app/:application_token", to: "chat_app#show", as: "chat_app"

  # Defines the custom route for creating a chat_app by application_token
  post "chat_app", to: "chat_app#create", as: "create_chat_app"

  # Defines the custom route for updating a chat_app by application_token
  patch "chat_app/:application_token", to: "chat_app#update", as: "update_chat_app"

  #=================================================================================
  # Chats routes: ==================================================================
  get "chat_app/:application_token/chats/:chat_number", to: "chats#show", as: "chat"
  post "chat_app/:application_token/chats", to: "chats#create", as: "create_chat"
  patch "chat_app/:application_token/chats/:chat_number", to: "chats#update", as: "update_chat"

  # Nested routes for chats under chat_apps application_token:
  # resources :chat_apps, param: :application_token, only: [] do
  #   resources :chats, only: [ :show ]
  # end
end
