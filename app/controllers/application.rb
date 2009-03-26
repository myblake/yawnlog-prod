# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  before_filter :add_stylesheets, :add_javascripts
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '034c3517a1245da226d6f18f9bb57c5a'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def initialize
    @stylesheets = []
    @javascripts = []
  end
  
  def add_stylesheets
    ["#{controller_name}/_controller", "#{controller_name}/#{action_name}"].each do |stylesheet|
      @stylesheets << stylesheet if File.exists? "#{Dir.pwd}/stylesheets/#{stylesheet}.css"
    end
  end
  
  def add_javascripts
    ["#{controller_name}/_controller", "#{controller_name}/#{action_name}"].each do |javascript|
      @javascripts << javascript if File.exists? "#{Dir.pwd}/javascripts/#{javascript}.js"
    end
  end
end
