module FriendsHelper
  
  def pending
    return !Friend.find(:first, :conditions => ["user_id_2=? and accepted=? and rejected=?",session[:user_id],false,false]).nil?
  end

end
