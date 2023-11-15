class UserMailer < ApplicationMailer
  
  def send_2fa_code(options)
    @user = options[:user]
    @preheader = "#{ENV['APP_NAME']} verification code"
    
    mail(to: @user.email, subject: "Your verification code")  
  end
  
end
