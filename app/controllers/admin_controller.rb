class AdminController < ApplicationController
  before_filter :authorize
  
  def index
    @users = User.find(:all)
    @size = @users.length
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
  
  
  protected
  def authorize 
    unless User.find_by_id(session[:user_id]).admin = true 
      redirect_to :controller => 'home'
    end 
  end
end
