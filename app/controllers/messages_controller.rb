class MessagesController < ApplicationController
  # Disable CSRF
  protect_from_forgery with: :null_session, only: [ :create ]
  before_action :find_chat

  def create
    message_params = params.require(:message).permit(:text)
    message_number = Sidekiq.redis { |conn| conn.incr("message_number:#{@chat.application_token}:#{@chat.chat_number}") }
    message_params = message_params.merge(message_number: message_number)

    MessageJob.perform_later("create", message_params, @chat.chat_number, @chat.application_token)
    render json: { message: "Creating message with number: #{message_number}" }, status: :accepted
  end

  def update
    message_params = params.require(:message).permit(:text)
    message_number = params[:message_number]
    message_params = message_params.merge(message_number: message_number)

    print("================ Message params:  #{message_params}")
    MessageJob.perform_later("update", message_params, @chat.chat_number, @chat.application_token)
    render json: { message: "Updating message with number: #{message_params[:message_number]}" }, status: :accepted
  end


  def find_chat
    chat_app = ChatApp.find_by(application_token: params[:application_token])
    render json: { error: "Chat app not found" }, status: :not_found and return unless chat_app

    @chat = chat_app.chats.find_by(chat_number: params[:chat_number])
    render json: { error: "Chat not found" }, status: :not_found unless @chat
  end
end
