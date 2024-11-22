# class MessageJob < ApplicationJob
#   queue_as :default

#   # This job will create the message in the database
#   def perform(action, message_params, chat_number, application_token)
#     # Find the ChatApp first
#     chat_app = ChatApp.find_by(application_token: application_token)
#     raise "ChatApp not found!!!!!!!!" unless chat_app

#     # Find the chat in the specified chat_app using the chat_number
#     chat = chat_app.chats.find_by(chat_number: chat_number)
#     raise "Chat not found!!!!" unless chat

#     # Debugging logs to check the params and chat
#     Rails.logger.info "MessageParams: #{message_params}"
#     Rails.logger.info "Chat found: #{chat.inspect}"

#     # Create a message number using Redis (if not passed, we assume message_number is a redis counter)
#     message_number = message_params[:message_number] || Sidekiq.redis { |conn| conn.incr("message_number:#{chat.application_token}:#{chat.chat_number}") }

#     # Create the message
#     begin
#       message = Message.create!(text: message_params[:text], message_number: message_number, chat_number: chat.chat_number, application_token: chat.application_token)
#       Rails.logger.debug "Message created successfully: #{message.inspect}"
#     rescue ActiveRecord::RecordInvalid => e
#       Rails.logger.error "Error creating message: #{e.message}"
#       raise e
#     end
#   end
# end

class MessageJob < ApplicationJob
  queue_as :default

  # This job will create the message in the database
  def perform(action, message_params, chat_number, application_token)
    # Find the ChatApp first
    chat_app = ChatApp.find_by(application_token: application_token)
    raise "ChatApp not found!" unless chat_app

    # Find the chat in the specified chat_app using the chat_number
    chat = chat_app.chats.find_by(chat_number: chat_number)
    raise "Chat not found!" unless chat

    case action
    when "create"
      message_number = message_params[:message_number]

      message = Message.new(text: message_params[:text], message_number: message_number, chat_number: chat.chat_number, application_token: chat.application_token)
      if message.save
        chat.increment!(:messages_count)
        Rails.logger.info "Message created successfully with message_number: #{message.message_number}"
      else
        Rails.logger.error "Failed to create message: #{message.errors.full_messages.join(', ')}"
      end

    when "update"
      Rails.logger.info "Message number: #{message_params[:message_number]}"
      message = Message.find_by(message_number: message_params[:message_number])
      raise "Message not found!" unless message

      if message.update(text: message_params[:text])
        Rails.logger.info "Message updated successfully with text: #{message.text}"
      else
        Rails.logger.error "Failed to update message: #{message.errors.full_messages.join(', ')}"
      end
    else
      Rails.logger.error "Invalid action: #{action}"
    end
  end
end
