class MessagesController < ApplicationController
  # Disable CSRF
  protect_from_forgery with: :null_session, only: [ :create ]
  before_action :find_chat

  def create
    message_params = params.require(:message).permit(:text)
    message_number = Sidekiq.redis { |conn| conn.incr("message_number:#{@chat.application_token}:#{@chat.chat_number}") }
    message_params = message_params.merge(message_number: message_number)

    MessageJob.perform_later("create", message_params, @chat.chat_number, @chat.application_token)
    render json: { message: "Creating message with number: #{message_params[:message_number]}" }, status: :accepted
  end

  def show
    message_number = params[:message_number]
    message = Message.find_by(message_number: message_number)

    if message
      render json: message.as_json(except: :id), status: :ok
    else
      render json: { error: "Message not found" }, status: :not_found
    end
  end

  def update
    message_params = params.require(:message).permit(:text)
    message_number = params[:message_number]
    message_params = message_params.merge(message_number: message_number)

    MessageJob.perform_later("update", message_params, @chat.chat_number, @chat.application_token)
    render json: { message: "Updating message with number: #{message_params[:message_number]}" }, status: :accepted
  end

  def search
    message_text = params[:query]
    if message_text.nil?
      render json: { error: "No text provided to search for" }, status: :not_found
    else
      @messages = Message.search(message_text).records
      render json: @messages.as_json(except: :id)
    end
  end


  def find_chat
    chat_app = ChatApp.find_by(application_token: params[:application_token])
    render json: { error: "Chat app not found" }, status: :not_found and return unless chat_app

    @chat = chat_app.chats.find_by(chat_number: params[:chat_number])
    render json: { error: "Chat not found" }, status: :not_found unless @chat
  end
end
