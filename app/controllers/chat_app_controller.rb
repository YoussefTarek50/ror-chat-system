class ChatAppController < ApplicationController
  # Disable CSRF
  protect_from_forgery with: :null_session, only: [ :create ]

  def create
    chat_app_data = {
      "name" => params.require(:chat_app).permit(:name)[:name],
      "application_token" => SecureRandom.hex(16) # Generate unique token
    }

    ChatAppJob.perform_later("create", chat_app_data)

    render json: {
      message: "ChatApp creation in progress.",
      application_token: chat_app_data["application_token"]
    }, status: :accepted
  end

  def index
    @chat_apps = ChatApp.all

    if @chat_apps
      render json: @chat_apps.as_json(except: :id), status: :ok
    else
      render json: { error: "No chat apps found" }, status: :not_found
    end
  end

  def show
    @chat_app = ChatApp.find_by(application_token: params[:application_token])

    if @chat_app
      render json: @chat_app.as_json(except: :id), status: :ok
    else
      render json: { error: "Chat app not found" }, status: :not_found
    end
  end

  def update
    chat_app_params = params.require(:chat_app).permit(:name).to_h
    application_token = params[:application_token]

    ChatAppJob.perform_later("update", chat_app_params, application_token)

    render json: { message: "Updating chat app with name: #{chat_app_params["name"]}" }, status: :accepted
  end
end
