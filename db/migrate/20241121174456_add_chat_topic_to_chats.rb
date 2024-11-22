class AddChatTopicToChats < ActiveRecord::Migration[7.2]
  def change
    add_column :chats, :chat_topic, :string
  end
end
