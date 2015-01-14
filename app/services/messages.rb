require 'open-uri'
require 'execjs'

class Messages
  attr_reader :js

  def initialize
    @context = V8::Context.new
  end

  def fetch
    response = fetch_new
    unless is_error(response)
      save_messages(response)
    else
      response['error']['message']
    end
  end

  def list
    Message.all
  end

  private

  def save_messages(response)
    messages = relevant_messages_for(response)
    messages.each do |message|
      Message.create(message)
    end
  end

  def relevant_messages_for(response)
    response.select { |item| relevant? item }
  end

  def is_error(response)
    response.is_a?(Hash) && response.has_key?('error')
  end

  def relevant?(item)
    item['message'].match(/(?:diet\s+)?(?:coke|coca(?:-|\s+)cola)/i)
  end

  def fetch_new
    ExecJS.eval(response_body)
  end

  def response_body
    make_request.read
  end

  def make_request
    open(Rails.application.config.messages_api_path)
  end
end
