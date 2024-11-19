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

  # Define the custom route for getting a chat_app by application_token
  get "chat_app/:application_token", to: "chat_app#show", as: "chat_app"

  # Define the custom route for creating a chat_app by application_token
  post "chat_app", to: "chat_app#create", as: "create_chat_app"

  # Define the custom route for updating a chat_app by application_token
  patch "chat_app/:application_token", to: "chat_app#update", as: "update_chat_app"
end
