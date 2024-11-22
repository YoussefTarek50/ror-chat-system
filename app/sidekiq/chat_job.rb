class ChatJob < ApplicationJob
  queue_as :default

  def perform(action, chat_params, application_token)
    Sidekiq.redis do |conn|
      if action == "create"
        conn.incr("chat_create_jobs_counter")
      elsif action == "update"
        conn.incr("chat_update_jobs_counter")
      end
    end

    chat_app = ChatApp.find_by(application_token: application_token)
    return unless chat_app

    case action
    when "create"
      chat = chat_app.chats.new(chat_params)
      if chat.save
        chat_app.increment!(:chat_count)
        Rails.logger.info "Chat created successfully with chat_number: #{chat.chat_number}, chat_topic: #{chat.chat_topic}"
      else
        Rails.logger.error "Failed to create chat: #{chat.errors.full_messages.join(', ')}"
      end

    when "update"
      chat = chat_app.chats.find_by(chat_number: chat_params[:chat_number])
      if chat.nil?
        Rails.logger.error "Chat not found for chat_number: #{chat_params[:chat_number]}"

      else
        if chat.update(chat_params)
          Rails.logger.info "Chat updated successfully: #{chat.inspect}"
        else
          Rails.logger.error "Failed to update chat: #{chat.errors.full_messages.join(', ')}"
        end
      end
    end
  end
end
