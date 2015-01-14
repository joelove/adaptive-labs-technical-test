class MessagesController < ApplicationController
  def index
    @messages = Messages.new.list
  end

  def fetch
    Messages.new.fetch
    redirect_to :action => "index"
  end
end
