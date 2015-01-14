require 'open-uri'
require 'execjs'

class Messages
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
      existing_message = Message.find_by(id: message['id'])
      if existing_message
        existing_message.increment!(:count)
      else
        Message.create(message.merge(count: 1))
      end
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
