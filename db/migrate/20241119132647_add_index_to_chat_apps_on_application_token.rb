class AddIndexToChatAppsOnApplicationToken < ActiveRecord::Migration[7.2]
  def change
    add_index :chat_apps, :application_token, unique: true
  end
end
