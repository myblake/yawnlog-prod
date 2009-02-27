class HomeController < ApplicationController  
  def index
    @news = News.find(:all, :conditions => ["created_at > ?", Date.today-7.days], :order => "id DESC")
  end

  def news
    authorize
  end
  
  def news_backend
    authorize
    @news = News.new(:text => params[:news][:text], :title => params[:news][:title])
    @news.save
    redirect_to :action => :index
  end
  
  def about
  end
  
  def failwhale
  end
  
  def tos
  end
  
  def privacy
  end
  
  protected
  def authorize 
    unless User.find_by_id(session[:user_id]).admin
      redirect_to :controller => 'home'
    end 
  end
  
end
