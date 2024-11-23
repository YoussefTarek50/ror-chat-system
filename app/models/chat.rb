class Chat < ApplicationRecord
  belongs_to :chat_app, foreign_key: "application_token", primary_key: "application_token", counter_cache: :chat_count
  has_many :messages, dependent: :destroy

  validates :chat_number, presence: true
  validates :application_token, presence: true
  validates :chat_topic, length: { maximum: 255 }

  validate :application_token_must_exist

  def application_token_must_exist
    unless ChatApp.exists?(application_token: application_token)
      errors.add(:application_token, "must correspond to an existing ChatApp")
    end
  end
end
