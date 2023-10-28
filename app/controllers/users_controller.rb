class UsersController < ApplicationController
  
  def request_2fa
    @user = User.find_by(email: params[:email])
    
    @user.send_new_one_time_code! if @user 
    
    @success = "If your email exists in our system you will shortly receive your 6 digit code."
  end 
  
  def confirm_2fa
    @attempts  = params[:attempts].to_i ||= 0

    if @attempts > 3
      @error = "To many resend attempts. Please again later."
    else 
      @attempts += 1
      @user      = User.find_by(email: params[:email])
      
      case params[:commit].downcase 
      when "resend"
        @user.send_one_time_code if @user 
        
      else     
        if @user 
          case @user.one_time_code == "#{params[:digit_1]}#{params[:digit_2]}#{params[:digit_3]}#{params[:digit_4]}#{params[:digit_5]}#{params[:digit_6]}".to_i
          when true  then @success = "Verification successful!"
          when false then @error   = "Verification unsuccessful"
          end
        end
      end
    end

  end

end
