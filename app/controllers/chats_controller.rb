class ChatsController < ApplicationController
  # Disable CSRF
  protect_from_forgery with: :null_session, only: [ :create ]
  before_action :find_chat_app

  def create
    next_chat_number = Sidekiq.redis { |conn| conn.incr("chat_number:#{@chat_app.application_token}") }
    chat_params = { chat_number: next_chat_number, chat_topic: params[:chat][:chat_topic] || "General" }

    ChatJob.perform_later("create", chat_params, @chat_app.application_token)
    render json: { message: "Create chat job ##{next_chat_number}" }, status: :accepted
  end

  def show
    chat = @chat_app.chats.find_by(chat_number: params[:chat_number])
    if chat
      render json: chat.as_json(except: :id), status: :ok
    else
      render json: { error: "Chat not found" }, status: :not_found
    end
  end

  def update
    chat_number = params[:chat_number]
    chat_topic = params[:chat][:chat_topic] || "General"
    chat_params = { chat_number: chat_number, chat_topic: chat_topic }

    ChatJob.perform_later("update", chat_params, @chat_app.application_token)

    render json: { message: "Update chat job with topic: #{chat_topic}" }, status: :accepted
  end

  def find_chat_app
    @chat_app = ChatApp.find_by(application_token: params[:application_token])
    render json: { error: "Chat app not found" }, status: :not_found if @chat_app.nil?
  end
end
