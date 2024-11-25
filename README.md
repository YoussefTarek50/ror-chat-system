# README

The chat apps system consists of APIs for creating, updating and viewing chat apps, chats, and messages.

Each chat app is identified by a unique token.
Each chat app has it's own chats, a chat has a unique chat number and a chat topic.
Each chat has it's own messages, a message has it's text, and a message number to identify it. Additionaly you can 
search for a message by a part of it's text.

The uniqueness of each entity is guaranteed by using redis.
A queuing system is used (sidekiq) to avoid heavy load on the server in case of several concurrent users,
the queuing system is used for creating or updating any of the entities.
The search for a message by part of it's text is done using elastic search.

Database schema can be foound in: db/schema.rb
Controllers can be found in: app/controllers
Workers/Jobs can be found in: app/sidekiq


Info about the system:

* Ruby version: ruby 3.1.2p20

* Rails version: 7.2.2

* Services: Sidekiq, Redis, Elasticsearch

* Running instructions: run the command: `docker compose up --build`

* Postman collection for REST APIs: Import from the file: RoR Chat System REST Copy.postman_collection.json

