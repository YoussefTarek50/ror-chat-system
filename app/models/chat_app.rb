class ChatApp < ApplicationRecord
  has_many :chats, foreign_key: "application_token", primary_key: "application_token", dependent: :destroy
  before_create :generate_token

  validates :name, presence: true

  def generate_token
    self.application_token = SecureRandom.hex(16)
  end
end
