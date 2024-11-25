class MakeMessageNumberUnique < ActiveRecord::Migration[7.2]
  def change
    remove_index :messages, name: "idx_on_message_number_chat_number_application_token_588d9de9f1"

    add_index :messages, [ :message_number, :chat_number, :application_token ], unique: true, name: "unique_message_number_per_chat"
  end
end
