class HomeController < ApplicationController
  before_filter :authorize, :except => [:index, :about, :failwhale]
  
  def index
    @news = News.find(:all, :conditions => ["created_at > ?", Date.today-7.days])
  end

  def news
  end
  
  def news_backend
    @news = News.new(:text => params[:news][:text], :title => params[:news][:title])
    @news.save
    redirect_to :action => :index
  end
  
  def about
  end
  
  def failwhale
  end
  
  protected
  def authorize 
    unless User.find_by_id(session[:user_id]).admin = true 
      redirect_to :controller => 'home'
    end 
  end
  
end
