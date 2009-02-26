class FriendsController < ApplicationController
  before_filter :authorize
  
  def index
    @friends_obj = Friend.find(:all, :conditions => ["(user_id_1=? or user_id_2=?) and accepted=?", session[:user_id],session[:user_id],true])
    @friends = []
    for friend in @friends_obj
      if friend.user_id_1 == session[:user_id]
        @friends.push(User.find(friend.user_id_2))
      else
        @friends.push(User.find(friend.user_id_1))
      end
    end
    @friend_requests = []
    @friend_requests_obj = Friend.find(:all, :conditions => ["(user_id_1=? or user_id_2=?) and accepted=? and rejected=?", session[:user_id],session[:user_id],false,false])
    for friend in @friend_requests_obj
      if friend.user_id_2 == session[:user_id]
        @friend_requests.push(User.find(friend.user_id_1))
      end
    end
  end

  def friend_request
    @user = User.find(params[:user_id])
    @friend = Friend.new(:user_id_1 => session[:user_id], :user_id_2 => params[:user_id], :accepted => false, :rejected => false)
    @friend.save
    if params[:redirect] = "index"
      flash[:notice] = "Your have requested to become friends with #{@user.username}"
      redirect_to :controller => "users", :action => "public_profiles"
      return
    end
  end
  
  def accept_friend
    if @friend = Friend.find(:first, :conditions => ["(user_id_1=? and user_id_2=?)", params[:user_id],session[:user_id]])
      @user = User.find(params[:user_id])
      @friend.accepted = true
      if @friend.save
        @newvar = Friend.find(:first, :conditions => ["(user_id_1=? and user_id_2=?)", params[:user_id],session[:user_id]])
        flash[:notice] = "Your are now friends with #{@user.username}"
        redirect_to :action => :index
        return
      else
         flash[:notice] = "An error has occured!!"
         redirect_to :action => :index
         return
      end
    else
      flash[:notice] = "An error has occured!!"      
      redirect_to :action => :index
    end
  end
  
  def reject_friend
    if @friend = Friend.find(:first, :conditions => ["(user_id_1=? and user_id_2=?)", params[:user_id],session[:user_id]])
      @user = User.find(params[:user_id])
      @friend.rejected = true
      if @friend.save
        @newvar = Friend.find(:first, :conditions => ["(user_id_1=? and user_id_2=?)", params[:user_id],session[:user_id]])
        flash[:notice] = "Your have rejected the friend request from #{@user.username}"
        redirect_to :action => :index
        return
      else
         flash[:notice] = "An error has occured!!"
         redirect_to :action => :index
         return
      end
    else
      flash[:notice] = "An error has occured!!"      
      redirect_to :action => :index
    end
  end
  
  protected 
  def authorize 
    unless User.find_by_id(session[:user_id]) 
      flash[:notice] = "Please log in" 
      redirect_to :controller => 'users', :action => 'login' 
    end 
  end
end
