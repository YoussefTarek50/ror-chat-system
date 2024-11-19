class CreateChatApps < ActiveRecord::Migration[7.2]
  def change
    create_table :chat_apps do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
