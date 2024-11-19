class AddTokenToChatApps < ActiveRecord::Migration[7.2]
  def change
    add_column :chat_apps, :application_token, :string
  end
end
