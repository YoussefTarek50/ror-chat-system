require 'rails_helper'

RSpec.describe "ChatAppController", type: :request do
  describe "POST /chat_app" do
    let(:valid_attributes) { { chat_app: { name: "New Chat App" } } }
    let(:invalid_attributes) { { chat_app: { name: "" } } }

    context "with valid parameters" do
      it "creates a new ChatApp" do
        expect {
          post "/chat_app", params: valid_attributes
        }.to change(ChatApp, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["message"]).to include("Chat app created successfully")
      end
    end

    context "with invalid parameters" do
      it "does not create a new ChatApp" do
        expect {
          post "/chat_app", params: invalid_attributes
        }.to_not change(ChatApp, :count)

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["errors"]).to include("Name can't be blank")
      end
    end
  end

  describe "GET /chat_app/:application_token" do
    let!(:chat_app) { ChatApp.create(name: "Test Chat App", application_token: "testtoken") }

    context "when the chat app exists" do
      it "returns the chat app" do
        get "/chat_app/#{chat_app.application_token}"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["name"]).to eq(chat_app.name)
      end
    end

    context "when the chat app does not exist" do
      it "returns a 404 status" do
        get "/chat_app/invalidtoken"
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Chat app not found")
      end
    end
  end

  describe "PATCH /chat_app/:application_token" do
    let!(:chat_app) { ChatApp.create(name: "Test Chat App", application_token: "testtoken") }
    let(:valid_update) { { chat_app: { name: "Updated Chat App" } } }
    let(:invalid_update) { { chat_app: { name: "" } } }

    context "with valid parameters" do
      it "updates the chat app" do
        patch "/chat_app/#{chat_app.application_token}", params: valid_update
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["name"]).to eq("Updated Chat App")
        expect(chat_app.reload.name).to eq("Updated Chat App")
      end
    end

    context "with invalid parameters" do
      it "does not update the chat app" do
        patch "/chat_app/#{chat_app.application_token}", params: invalid_update
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to include("Name can't be blank")
        expect(chat_app.reload.name).to eq("Test Chat App")
      end
    end

    context "when the chat app does not exist" do
      it "returns a 404 status" do
        patch "/chat_app/invalidtoken", params: valid_update
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Chat app not found")
      end
    end
  end
end
