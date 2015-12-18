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
end