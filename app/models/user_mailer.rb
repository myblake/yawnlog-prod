class UserMailer < ActionMailer::Base
  def forgot_password(user, password)
     subject    'Your New Yawnlog Password'
     recipients user.email 
     from       'team@yawnlog.com'
     sent_on    Time.now

     body       :user => user, :password => password
   end  

end
