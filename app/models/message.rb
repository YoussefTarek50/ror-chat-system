class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: { number_of_shards: 1 } do
    mappings dynamic: false do
      indexes :text, type: :text, analyzer: "english"
    end
  end

  belongs_to :chat, foreign_key: [ :chat_number, :application_token ],
                                    primary_key: [ :chat_number, :application_token ], counter_cache: :messages_count


  after_create :index_message
  validates :text, presence: true

  def as_indexed_json(options = {})
    as_json(only: [ :text, :application_token, :chat_number, :message_number ])
  end

  def index_message
    self.__elasticsearch__.index_document
  end
end
