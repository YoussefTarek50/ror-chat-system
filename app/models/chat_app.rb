class ChatApp < ApplicationRecord
  has_many :chats, foreign_key: "application_token", primary_key: "application_token", dependent: :destroy

  validates :name, presence: true
end
