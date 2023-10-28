class SubscribersController < ApplicationController
  invisible_captcha only: [:subscribe_to_newsletter], honeypot: :subscribe, on_spam: :redirect_to_home
  
  def subscribe_to_newsletter
    ml = MailingList.find(params[:mailing_list_id])
    @subscriber  = ml.subscribers.create({ email: params[:email]})
    
    Rails.logger.info @subscriber.errors.inspect
    
    if @subscriber.valid?
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("launch_subscribe", partial: 'home/launch/thanks') }
      end
    else 
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("launch_subscribe", partial: 'home/launch/subscribe') }
      end
    end
    
  end 
  
  def confirm_news_letter_subscription 
  end 
  
end
