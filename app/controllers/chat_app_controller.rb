class ChatAppController < ApplicationController
  # Disable CSRF
  protect_from_forgery with: :null_session, only: [ :create ]

  def create
    chat_app_params = params.require(:chat_app).permit(:name).to_h
    ChatAppJob.perform_later("create", chat_app_params)

    count = Sidekiq.redis { |conn| conn.get("chat_app_create_jobs_counter").to_i }
    render json: { message: "Createing chat app job ##{count}" }, status: :accepted
  end

  def show
    @chat_app = ChatApp.find_by(application_token: params[:application_token])
    print("Chat app: #{@chat_app}")

    if @chat_app
      render json: @chat_app, status: :ok
    else
      render json: { error: "Chat app not found" }, status: :not_found
    end
  end

  def update
    chat_app_params = params.require(:chat_app).permit(:name).to_h
    application_token = params[:application_token]

    ChatAppJob.perform_later("update", chat_app_params, application_token)

    count = Sidekiq.redis { |conn| conn.get("chat_app_update_jobs_counter").to_i }
    render json: { message: "Updating chat app job ##{count}" }, status: :accepted
  end
end
