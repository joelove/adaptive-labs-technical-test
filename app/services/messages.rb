require 'open-uri'
require 'execjs'

class Messages
  attr_reader :response, :message

  def fetch
    if fetch_messages
      save_messages
    else
      error_msg
    end
  end

  def list
    Message.all
  end

  def clear
    Message.delete_all
  end

  private

  def fetch_messages
    json = response_body
    @response = ExecJS.eval(json) if json
  end

  def save_messages
    unless response_error?
      add_messages
    else
      response['error']['message']
    end
  end

  def response_body
    response = make_request
    response.read if response
  end

  def response_error?
    response.is_a?(Hash) && response.has_key?('error')
  end

  def add_messages
    new_messages = relevant_messages
    new_messages.each do |message|
      @message = message
      add_or_update
    end
    success_msg(new_messages.size)
  end

  def make_request
    begin
      open(Rails.application.config.messages_api_path)
    rescue OpenURI::HTTPError => e
      nil
    end
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

  def success_msg(count)
    "Retrieved #{count} relevant message(s)"
  end

  def error_msg
    "Error getting messages"
  end
end
