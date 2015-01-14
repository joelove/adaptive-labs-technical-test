require 'open-uri'
require 'execjs'

class Messages
  attr_reader :response, :message

  def fetch
    fetch_messages
    save_messages
  end

  def list
    Message.all
  end

  private

  def fetch_messages
    @response = ExecJS.eval(response_body)
  end

  def save_messages
    unless is_error
      add_messages
    else
      response['error']['message']
    end
  end

  def response_body
    make_request.read
  end

  def is_error
    response.is_a?(Hash) && response.has_key?('error')
  end

  def add_messages
    relevant_messages.each do |message|
      @message = message
      add_or_update
    end
  end

  def make_request
    open(Rails.application.config.messages_api_path)
  end

  def relevant_messages
    response.select { |item| relevant? item }
  end

  def add_or_update
    if existing_message
      existing_message.increment!(:count)
    else
      add_message
    end
  end

  def existing_message
    Message.find_by(id: message['id'])
  end

  def add_message
    Message.create(message.merge(count: 1))
  end

  def relevant?(item)
    item['message'].match(/(?:diet\s+)?(?:coke|coca(?:-|\s+)cola)/i)
  end
end
