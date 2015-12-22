class PagesController < ApplicationController
  before_filter :authenticate_admin, only: [:dashboard]

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
  	@tags = Tag.all.order('name')
  	@users = User.all.order('first_name')
  	@pending_events = Event.where(status: "Pending").order('start_date ASC')
  	render :template => "pages/dashboard"
  end

  
end