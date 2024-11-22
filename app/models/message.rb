class Message < ApplicationRecord
  belongs_to :chat, foreign_key: [ :chat_number, :application_token ],
                                    primary_key: [ :chat_number, :application_token ]

  validates :text, presence: true
end
