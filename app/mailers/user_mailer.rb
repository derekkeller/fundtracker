class UserMailer < ActionMailer::Base
  default :from => "webmaster@development.com"
  
  def password_recovery_link(user)
    @user = user
    mail(:to => "#{user.to_s} <#{user.email}>", :subject => "Password reset link")
  end
  
end
