class UserMailer < ApplicationMailer
  
  def send_2fa_code(options)
    @user = options[:user]
    
    mail(to: @user.email, subject: "Your verification code")  
  end
  
end
