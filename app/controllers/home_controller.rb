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
  
  def feedback
    unless session[:user_id]
      flash[:notice] = "Please log in" 
      redirect_to :controller => 'users', :action => 'login' 
      return
    end 
    if params[:feedback]
      unless params[:feedback][:body] != ""
        flash[:notice] = "We <3 user feedback, so we don't want your message to be empty!"
        return
      end
      @feedback = Feedback.new(:body => params[:feedback][:body], :user_id => session[:user_id])
      if @feedback.save
        flash[:notice] = "Feedback has been sent, thanks!"
      else
        flash[:notice] = "Hmm an error has occcured with your feedback. Try again?"
      end
      redirect_to :action => :index
    end
        
  end
  
  protected
  def authorize 
    unless User.find_by_id(session[:user_id]).admin
      redirect_to :controller => 'home'
    end 
  end
  
end
