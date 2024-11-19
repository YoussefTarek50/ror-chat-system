class ChatAppController < ApplicationController
  # Disable CSRF
  protect_from_forgery with: :null_session, only: [ :create ]

  def create
    @chat_app = ChatApp.new(params.require(:chat_app).permit(:name))

    if @chat_app.save
      render json: { message: "Chat app created successfully with ID: #{@chat_app.id}" }, status: :created
    else
      render json: { errors: @chat_app.errors.full_messages }, status: :bad_request
    end
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
    @chat_app = ChatApp.find_by(application_token: params[:application_token])

    if @chat_app.nil?
      render json: { error: "Chat app not found" }, status: :not_found

    else
      if @chat_app.update(params.require(:chat_app).permit(:name))
        render json: @chat_app, status: :ok

      else
        render json: { error: @chat_app.errors.full_messages }, status: :bad_request

      end
    end
  end
end
