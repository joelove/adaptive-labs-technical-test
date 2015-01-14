require 'open-uri'
require 'execjs'

class Messages
  attr_reader :js

  def initialize
    @context = V8::Context.new
  end

  def fetch
    response = fetch_new
    messages = response.select { |item| relevant? item }
    messages.each { |message| Message.create(message) }
  end

  def list
    Message.all
  end

  private

  def relevant?(item)
    item['message'].match(/(?:diet\s+)?(?:coke|coca(?:-|\s+)cola)/i) # "relevant is very vauge"
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
