class AddIndexToChatsOnChatNumberAndApplicationToken < ActiveRecord::Migration[7.2]
  def change
    add_index :chats, [ :chat_number, :application_token ], unique: true
  end
end
