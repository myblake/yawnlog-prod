class AdminController < ApplicationController
  before_filter :authorize
  
  def index
    @users = User.paginate(:page => params[:page], :per_page => 100)
    @size = User.count
    @active_users_today = User.count(:conditions => ["(last_login_at != NULL and last_login_at > ?) or (last_sleep_at != null and last_sleep_at > ?)", Time.now - 1.days, Time.now - 1.days])
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
  
  def sleep
    @sleeps = Sleep.find(:all, :order => "start DESC")
    @sleep_size = @sleeps.length
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
    @feedbacks = Feedback.find(:all, :order => "created_at DESC")
  end
  
  protected
  def authorize 
    unless User.find_by_id(session[:user_id]).admin
      redirect_to :controller => 'home'
    end 
  end
end
