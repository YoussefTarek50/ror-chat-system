class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.string :application_token, null: false
      t.integer :chat_number, null: false
      t.integer :message_number, null: false
      t.string :text, null: false
      t.timestamps
    end
    add_foreign_key :messages, :chats, column: [ :chat_number, :application_token ],
                                       primary_key: [ :chat_number, :application_token ]

    add_index :messages, [ :message_number, :chat_number, :application_token ]
  end
end
