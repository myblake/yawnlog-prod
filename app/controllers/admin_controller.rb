class AdminController < ApplicationController
  before_filter :authorize
  
  def index
    @size = User.count
    #@active_users_today = User.count(:conditions => ["last_login_at > '2009-03-29 00:00:00'"])
    @last_login = []
    @last_login[0] = @size
    (1..7).each do |i|
      @last_login[i] = User.count(:conditions => ["last_login_at > ?", (Time.now - i.days).strftime("%Y-%m-%d %H:%M:%S")])
      @last_login[0] -= @last_login[i]
#      @sleep_quality[i] = Sleep.count(:conditions => ["quality = ?", i])
#      @sleep_quality[0] -= @sleep_quality[i]
    end
    
  end
  
  def all_users
    if params[:order]
      @order = params[:order]
      if params[:asc] == "asc"
        @order += " ASC"
      else
        @order += " DESC"
      end
    else
      @order = "username ASC"
    end
    @users = User.paginate(:page => params[:page], :per_page => 100, :order => @order)
  end
  
  def edit
    @user = User.find(params[:id])
    if params[:user]
      @user.admin = params[:user][:admin]
      if @user.save
        flash[:notice] = "#{@user.username} settings are updated!"
        redirect_to :controller => "admin", :action => :index
      else
        redirect_to :action => :edit
      end
    end             
  end
  
  def reset_password
    @user = User.find(params[:id])
    @user.password = Digest::SHA1.hexdigest("yawnlog")
    if @user.save
      flash[:notice] = "#{@user.username}'s password was reset to \"yawnlog\""
      redirect_to :controller => "admin", :action => :index
    else
      redirect_to :action => :edit
    end
  end
  
  def all_sleep
    if params[:order]
      @order = params[:order]
      if params[:asc] == "asc"
        @order += " ASC"
      else
        @order += " DESC"
      end
    else
      @order = "start DESC"
    end
    @sleeps = Sleep.paginate(:page => params[:page], :per_page => 100, :order => @order )
  end
  
  def sleep
    @sleep_size = Sleep.count
    @sleep_quality = []
    @sleep_quality[0] = @sleep_size
    (1..5).each do |i|
      @sleep_quality[i] = Sleep.count(:conditions => ["quality = ?", i])
      @sleep_quality[0] -= @sleep_quality[i]
    end
  end
  
  def special_method
    @users = User.find(:all)
    for user in @users
      user.num_of_sleeps = user.sleeps.length
      user.save
    end
    flash[:notice] = "all set"
    redirect_to :controller => "admin", :action => :index
  end

  def feedback
    @feedbacks = Feedback.paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
    if params[:response]
      @feedbacks[params[:response][:index].to_i].response = params[:response][:response] + " " + session[:user_username] + Time.now.strftime(" at %I:%M %p on %a %b %d")
      if @feedbacks[params[:response][:index].to_i].save
      end
    end
  end
  
  protected
  def authorize 
    unless session[:user_id] and User.find_by_id(session[:user_id]).admin
      redirect_to :controller => 'home'
    end 
  end
end
