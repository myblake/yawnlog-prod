class SleepsController < ApplicationController
  before_filter :authorize, :except => [:cache_update]
  
  def cache_update
    #terrible hack here, due to putting business logic in helpers instead of controllers which should only be used for markup
  end
  
  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"] =~ /iPhone/
    puts request.env["HTTP_USER_AGENT"]
  end
  
  # GET /sleeps
  # GET /sleeps.xml
  def index
    @iphone = iphone_user_agent?
    if params[:start]
      if params[:start] == "today"
        @start = Date.today
      else
        @start = Date.parse(params[:start])
      end
    else
      @start = Date.today-7.days
    end
    
    if params[:stop]
      if params[:stop] == "today"
        @stop = Date.today
      else
        @stop = Date.parse(params[:stop])
      end
    else
      @stop = Date.today
    end

    if params[:end_of_day]
      @end_of_day = params[:end_of_day].to_i
    else
      @end_of_day = 24
    end

    @sleeps = Sleep.find(:all, :conditions => ["user_id=?", session[:user_id]], :order => "start DESC")
    @sleep = Sleep.new
    @user = User.find(session[:user_id])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sleeps }
    end
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


  def create_sleep_backend
    #asdf
    #start = Time.parse(params[:sleep][:start] + params[:sleep][:date])
    start = params[:start]
    stop = params[:stop]
    date = params[:sleep][:date]
    start = Time.parse(start + " " + date + " UT")
    stop = Time.parse(stop + " "+ date + " UT")
    
    test = start
    test2 = stop

    if start.hour > 16
      start -= 1.days
    end
 
    if stop.hour > 16
      stop -= 1.days
    end
    
    if Time.now.isdst
      start -= 7.hours
      stop -= 7.hours
    else
      start -= 8.hours
      stop -= 8.hours
    end
    
    puts start
    puts stop
    
    @sleep = Sleep.new(
      :zip => params[:sleep][:zip],
      :quality => params[:sleep][:quality],
      :note => params[:sleep][:note],
      :start => start,
      :stop => stop
      )
    @sleep.user_id = session[:user_id] 
    if @sleep.user.num_of_sleeps
      @sleep.user.num_of_sleeps += 1
    else
      @sleep.user.num_of_sleeps = 0
    end
    @sleep.user.last_sleep_at = Time.now
    @sleep.user.save 
    if @sleep.save
      flash[:notice] = 'Sleep was successfully created.'
      flash[:error]
      redirect_to :action => :index
    else
      flash[:notice] = "Something terrible has happened! But now we know why:<br />#{@sleep.errors.on(:stop)} #{@sleep.errors.on(:id)}"
      flash[:error]
      redirect_to :action => :index
    end

  end

  #
  # Eventually we should fix all the RESTful stuff to all or (more likely unfortunately) not
  #
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
    #vicious hack. sorry to whoever is reading this even me again.
    if params[:chart]
      redirect_to :action => :index, :params => params[:chart]
      return
    end
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
      format.html { redirect_to(:action => :index) }
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