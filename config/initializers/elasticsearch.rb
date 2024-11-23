require "elasticsearch/model"

Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV["ELASTICSEARCH_URL"] || "https://localhost:9200", # Use HTTPS
  user: ENV["ELASTICSEARCH_USER"] || "elastic", # Set your Elasticsearch username
  password: ENV["ELASTICSEARCH_PASSWORD"] || "Kq6hRS*dsQvyWf3tQiB0", # Set your Elasticsearch password
  transport_options: {
    request: { timeout: 5 }, # Optional: set a timeout
    ssl: { verify: false }   # Optional: disable SSL verification (not recommended for production)
  }
)

# Create the 'messages' index if it doesn't exist
client = Elasticsearch::Client.new(
  url: ENV["ELASTICSEARCH_URL"] || "https://localhost:9200",
  user: ENV["ELASTICSEARCH_USER"] || "elastic",
  password: ENV["ELASTICSEARCH_PASSWORD"] || "Kq6hRS*dsQvyWf3tQiB0",
  transport_options: { ssl: { verify: false } }
)

index_name = "messages"

unless client.indices.exists?(index: index_name)
  client.indices.create(
    index: index_name,
    body: {
      settings: {
        number_of_shards: 1,
        number_of_replicas: 1
      },
      mappings: {
        properties: {
          text: { type: "text" },
          chat_number: { type: "integer" },
          message_number: { type: "integer" }
        }
      }
    }
  )
  puts "Created Elasticsearch index '#{index_name}'"
end
