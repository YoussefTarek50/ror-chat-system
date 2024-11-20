class CreateChats < ActiveRecord::Migration[7.2]
  def change
    create_table :chats do |t|
      t.integer :chat_number, null: false
      t.string :application_token, null: false
      t.timestamps
    end

    add_foreign_key :chats, :chat_apps, column: :application_token, primary_key: :application_token
    add_index :chats, :application_token
    add_index :chats, :chat_number
  end
end
