class ChatAppJob < ApplicationJob
  queue_as :default

  def perform(action, chat_app_params, application_token = nil)
    Rails.logger.info "Performing #{action} action with params: #{chat_app_params.inspect}"

    case action
    when "create"
       # Find or initialize the ChatApp
       chat_app = ChatApp.new(application_token: chat_app_params["application_token"])
       chat_app.name = chat_app_params["name"]

       if chat_app.save
         Rails.logger.info "ChatApp with token #{chat_app.application_token} created successfully."
       else
         Rails.logger.error "Failed to create ChatApp: #{chat_app.errors.full_messages.join(', ')}"
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
