class MessagesController < ApplicationController
  def index
    @messages = Messages.list
  end

  def fetch
    Messages.fetch
    redirect_to :action=>'index'
  end
end
