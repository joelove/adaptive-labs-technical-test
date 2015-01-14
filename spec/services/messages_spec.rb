require 'rails_helper'

RSpec.describe Messages do

  let(:positive_response) do
    %{
      [
        {
          created_at: "2012-09-27T16:16:26Z",
          followers: 9,
          id: 10,
          message: "Coca cola sucks, man",
          sentiment: -0.6,
          updated_at: "2012-09-27T16:16:26Z",
          user_handle: "@disser_ono"
        },
        {
          created_at: "2012-12-07T16:57:12Z",
          followers: 5,
          id: 17,
          message: "Coke is great",
          sentiment: 0.7,
          updated_at: "2012-12-07T16:57:12Z",
          user_handle: "@coke_lvr"
        }
      ]
    }
  end

  let(:negative_response) do
    %{
      [
        {
          created_at: "2012-12-07T16:55:45Z",
          followers: 3,
          id: 16,
          message: "Hi there",
          sentiment: 0,
          updated_at: "2012-12-07T16:55:45Z",
          user_handle: "@idiot"
        },
        {
          created_at: "2012-09-27T16:14:27Z",
          followers: 9,
          id: 7,
          message: "Vimto or Ribena? You decide!",
          sentiment: 0.2,
          updated_at: "2012-09-27T16:14:27Z",
          user_handle: "@mad4vimto"
        }
      ]
    }
  end

  let(:error_response) do
    %{
      {
        error: {
          message: "Server error"
        }
      }
    }
  end

  context "when no messages have been fetched" do
    it "lists no messages" do
      expect(subject.list).to eq([])
    end
  end

  context "when two messages about coke are fetched" do
    before do
      stub_request(:get, Rails.application.config.messages_api_path)
        .to_return(status: 200, body: positive_response, headers: {})

      subject.fetch
    end

    it "lists two messages" do
      expect(subject.list.length).to eq(2)
    end

    it "clears messages" do
      subject.clear
      expect(subject.list.length).to eq(0)
    end
  end

  context "when two irrelevant message are fetched" do
    before do
      stub_request(:get, Rails.application.config.messages_api_path)
        .to_return(status: 200, body: negative_response, headers: {})

      subject.fetch
    end

    it "lists no messages" do
      expect(subject.list).to eq([])
    end
  end

  context "when the api returns an error" do
    before do
      stub_request(:get, Rails.application.config.messages_api_path)
        .to_return(status: 200, body: error_response, headers: {})
    end

    it "returns the error message" do
      expect(subject.fetch).to eq("Server error")
    end
  end

  context "when multiple responses contain the same message" do
    before do
      stub_request(:get, Rails.application.config.messages_api_path)
        .to_return(status: 200, body: positive_response, headers: {})

      subject.fetch
      subject.fetch
    end

    it "increments the count on the duplicate message" do
      message = subject.list.first
      expect(message.count).to eq(2)
    end
  end

  context "when there is a server error" do
    before do
      stub_request(:get, Rails.application.config.messages_api_path)
        .to_return(status: 500)
    end

    it "returns an error string" do
      expect(subject.fetch).to eq("Error getting messages")
    end
  end
end
