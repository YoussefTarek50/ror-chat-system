class ChatApp < ApplicationRecord
  before_create :generate_token

  validates :name, presence: true


  def generate_token
    self.application_token = SecureRandom.hex(16)
  end
end
