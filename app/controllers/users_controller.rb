require 'digest/sha1'

class UsersController < ApplicationController

  before_filter :authorize, :except => [:login, :signup, :signup_backend, :login_backend, :user, :forgot_password, :create_forgot_password]
  
  def share
  end
  
  def signup
    if session[:user_id]
      redirect_to :controller => "sleeps"
    end
	end
	
	def signup_backend
	  sha_passwd = Digest::SHA1.hexdigest(params[:user][:password])
	  if params[:user][:password] != params[:user][:password_confirm]
	    flash[:notice] = "Passwords don't match."
			redirect_to :action => :signup
      return
		end
		if params[:user][:twitter].length > 15
		  flash[:notice] = "Twitter name too long."
      redirect_to :action => :signup
      return
    end
		@user = User.new(:username => params[:user][:username],
		                :email => params[:user][:email],
		                :password => sha_passwd,
		                :realname => params[:user][:realname],
		                :zip => params[:user][:zip],
		                :twitter => params[:user][:twitter].sub(/\@*/,''),
                    :zip => params[:user][:zip],
		                :target_hours => params[:user][:target_hours],
		                :public_profile => params[:user][:public_profile],
		                :last_login_at => Time.now,
		                :num_of_sleeps => 0)
		if @user.save
			redirect_to :action => :login_backend, :user => {:username => params[:user][:username], :password => params[:user][:password]}
		else
			redirect_to :action => :signup
		end
	end
	
	def public_profiles
	  @users = User.find(:all)
  end
  
  def user    
    unless @user = User.find(:first, :conditions => ["username like ?",params[:username]])
      flash[:notice] = "User does not exist or does not have a public profile."
      redirect_to :controller => "home", :action => :index
      return
    end
    @friends = Friend.find(:first, :conditions => ["(user_id_1=? and user_id_2=?) or (user_id_1=? and user_id_2=?)", session[:user_id], @user.id, @user.id, session[:user_id]])
    unless @user.public_profile || User.find(session[:user_id]).admin || @friends
      @show = false
    else
      @show = true
		end
	end
	
	def login_backend
		username = params[:user][:username]
		password = Digest::SHA1.hexdigest(params[:user][:password])
		user = User.find :first, :conditions => ["username=? and password=?", username, password]
		if user
			session[:user_id] = user.id
      session[:user_username] = user.username
      user.last_login_at = Time.now
      user.save
      if user.pw_reset
        redirect_to :action => :password_reset
        return
      end
			redirect_to :controller => "sleeps", :action => :index
		else
			flash[:notice] = "Incorrect username or password."
			redirect_to :controller => "users", :action => :login
		end
	end
	
	def password_reset
    @user = User.find(session[:user_id])
    if params[:user]
      if params[:user][:password] != params[:user][:password_confirm]
  	    flash[:notice] = "Passwords don't match"
        return
  		end
  	  @user.password = Digest::SHA1.hexdigest(params[:user][:password])
  	  @user.pw_reset = false
  	  if @user.save
        flash[:notice] = "Your settings are updated!"
        redirect_to :controller => :home, :action => :index
      else
        flash[:notice] = "Error saving new settings."
      end
    end
  end
	
	def logout
		session[:user_id] = nil
		session[:user_username] = nil
		flash[:notice] = "You are now logged out."
		redirect_to :controller => "home", :action => :index
	end

  def edit
    @user = User.find(session[:user_id])
    if params[:user]
      if params[:user][:twitter].length > 15
  		  flash[:notice] = "Twitter name too long."
        redirect_to :action => :edit
        return
      end
      @user.email = params[:user][:email];
      @user.realname = params[:user][:realname]
      @user.public_profile = params[:user][:public_profile]
      @user.target_hours = params[:user][:target_hours]
      @user.twitter = params[:user][:twitter].sub(/\@*/,'')
      @user.zip = params[:user][:zip]
      if params[:user][:password] != ""
      
        if params[:user][:password] != params[:user][:password_confirm]
    	    flash[:error] = "Passwords don't match"
    			redirect_to :action => :edit
          return
    		end
    	  @user.password = Digest::SHA1.hexdigest(params[:user][:password])
    	end
      if @user.save
        flash[:notice] = "Your settings are updated!"
        redirect_to :controller => "home", :action => :index
      else
        redirect_to :action => :edit
      end               
    end
  end
  
  def create_forgot_password
    if session[:user_id]
      redirect_to :action => :index
      return
    end

    if params[:user][:username] and !params[:user][:username].empty?
      user = User.find(:first, :conditions => ["username=?", params[:user][:username]])
    elsif params[:user][:email]
      user = User.find(:first, :conditions => ["email=?", params[:user][:email]])
    end
    if user
      if user.pw_reset
        flash[:notice] = "Password has been recently reset, please check you inbox"
        redirect_to :action => :login
        return
      end
      password = Digest::SHA1.hexdigest(Time.now.to_s).to_s[0..7]
  	  sha_passwd = Digest::SHA1.hexdigest(password) 
  	  user.password = sha_passwd
  	  user.pw_reset = true
      if UserMailer.deliver_forgot_password(user, password)
        flash[:notice] = "Please check your email for a new password."
  	    user.save
      end
    else
      flash[:notice] = "Could not find user account for username #{params[:username]}"
    end
    redirect_to :controller => :home, :action => :index
  end
  
  protected 
  def authorize 
    unless User.find_by_id(session[:user_id]) 
      flash[:notice] = "Please log in" 
      redirect_to :controller => 'users', :action => 'login' 
    end 
  end
  
end
