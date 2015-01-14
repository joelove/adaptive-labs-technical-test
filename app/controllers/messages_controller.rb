class MessagesController < ApplicationController
  def index
    @messages = Messages.new.list
  end

  def fetch
    redirect_to :action => "index", :notice => Messages.new.fetch
  end

  def clear
    Messages.new.clear
    redirect_to :action => "index"
  end
end
