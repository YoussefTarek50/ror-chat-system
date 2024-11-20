class ChatAppJob < ApplicationJob
  queue_as :default

  def perform(action, chat_app_params, application_token = nil)
    Rails.logger.info "Performing #{action} action with params: #{chat_app_params.inspect}"

    Sidekiq.redis do |conn|
      if action == "create"
        conn.incr("chat_app_create_jobs_counter")
      elsif action == "update"
        conn.incr("chat_app_update_jobs_counter")
      end
    end

    case action
    when "create"
      chat_app = ChatApp.new(chat_app_params)
      if chat_app.save
        Rails.logger.info "Chat app created successfully with ID: #{chat_app.id}"
      else
        Rails.logger.error "Failed to create chat app: #{chat_app.errors.full_messages.join(', ')}"
      end
    when "update"
      chat_app = ChatApp.find_by(application_token: application_token)
      if chat_app.nil?
        Rails.logger.error "Chat app not found for token: #{application_token}"
      else
        if chat_app.update(chat_app_params)
          Rails.logger.info "Chat app updated successfully: #{chat_app.inspect}"
        else
          Rails.logger.error "Failed to update chat app: #{chat_app.errors.full_messages.join(', ')}"
        end
      end
    else
      Rails.logger.error "Invalid action: #{action}"
    end
  end
end
