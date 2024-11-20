class AddChatCountColumnToChatApps < ActiveRecord::Migration[7.2]
  def change
    add_column :chat_apps, :chat_count, :integer, default: 0,  null: false
  end
end
