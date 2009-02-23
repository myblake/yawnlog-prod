class SleepsController < ApplicationController
  before_filter :authorize
  
  # GET /sleeps
  # GET /sleeps.xml
  def index
    @sleeps = Sleep.find(:all, :conditions => ["user_id=?", session[:user_id]])
    @user = User.find(session[:user_id])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sleeps }
    end
    @quality_string 
  end

  # GET /sleeps/1
  # GET /sleeps/1.xml
  def show
    @sleep = Sleep.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sleep }
    end
  end

  # GET /sleeps/new
  # GET /sleeps/new.xml
  def new
    @sleep = Sleep.new
    @user = User.find(session[:user_id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sleep }
    end
  end

  # GET /sleeps/1/edit
  def edit
    @sleep = Sleep.find(params[:id])
    if @sleep.user_id != session[:user_id]
      flash[:notice] = 'Sleep record belongs to another user.'
      redirect_to :controller => 'home'
      return
    end
  end

  # POST /sleeps
  # POST /sleeps.xml
  def create
    @sleep = Sleep.new(params[:sleep])
    @sleep.user_id = session[:user_id]

    respond_to do |format|
      if @sleep.save
        flash[:notice] = 'Sleep was successfully created.'
        format.html { redirect_to(@sleep) }
        format.xml  { render :xml => @sleep, :status => :created, :location => @sleep }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sleep.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sleeps/1
  # PUT /sleeps/1.xml
  def update
    @sleep = Sleep.find(params[:id])

    if @sleep.user_id != session[:user_id]
      flash[:notice] = 'Sleep record belongs to another user.'
      redirect_to :controller => 'home'
      return
    end
    
    respond_to do |format|
      if @sleep.update_attributes(params[:sleep])
        flash[:notice] = 'Sleep was successfully updated.'
        format.html { redirect_to(@sleep) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sleep.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sleeps/1
  # DELETE /sleeps/1.xml
  def destroy
    @sleep = Sleep.find(params[:id])
    
    if @sleep.user_id != session[:user_id]
      flash[:notice] = 'Sleep record belongs to another user.'
      redirect_to :controller => 'home'
      return
    end
    
    @sleep.destroy

    respond_to do |format|
      format.html { redirect_to(sleeps_url) }
      format.xml  { head :ok }
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