class PagesController < ApplicationController
  def index
    render :template => "pages/index"
  end

  def about
    render :template => "pages/about"
  end

  def pie
    render :template => "pages/pie"
  end

  def dashboard
  	@tags = Tag.all
  	@users = User.all
  	@pending_events = Event.where(status: "Pending")
  	render :template => "pages/dashboard"
  end

  
end