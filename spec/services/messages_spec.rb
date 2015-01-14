require 'rails_helper'

RSpec.describe Messages do

  let(:response_body) do
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
        .to_return(status: 200, body: response_body, headers: {})

      subject.fetch
    end

    it "lists two messages" do
      expect(subject.list.length).to eq(2)
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
end
