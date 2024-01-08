class HomeController < ApplicationController
  
  def index 
  end
  
  
  def subscribe_to_newsletter
  end 
  
  
  if !Rails.env.production?
    def set_for_testing 
      clear_shopping_cart
    end    
  end
  
  def qr_code 
  end 
  
  def bitly 
    campaign = Campaign.find_by(tag: params[:bitly])
    if campaign and !campaign.redirect_url.blank?
      
      # TODO: save click data - referrer, ip_address, etc..
      campaign.add_one_to_clicks!
      redirect_to(campaign.redirect_url, status: 302, allow_other_host: true) and return
    end

    render plain: "There may be a problem. Let me check. I might be awhile", status: 400
  end 
  
  def image_s 
    image 
    communications_sent = CommunicationSent.find_by(campaign_id: params[:campaign_id], communication_id: params[:communication_id], subscriber_id: params[:subscriber_id])
    communications_sent.add_one_to_opens!(request_ip_address)
  end
  
  def image_u 
    image 
    communications_sent = CommunicationSent.find_by(campaign_id: params[:campaign_id], communication_id: params[:communication_id], user_id: params[:user_id])
    communications_sent.add_one_to_opens!(request_ip_address)
  end
  
  def image 

    # TODO: if file does not exist, send default image
    
    send_file(
      "app/assets/images/email/#{params[:image]}.png",
      disposition: 'inline',
      type:        'image/png',
      x_sendfile:  true
    )
    
    communications_sent = if params[:campaign_id] and params[:communication_id]
                            if params[:subscriber_id]
                              CommunicationSent.find_by(campaign_id: params[:campaign_id], communication_id: params[:communication_id], subscriber_id: params[:subscriber_id])
                            elsif params[:user_id]
                              CommunicationSent.find_by(campaign_id: params[:campaign_id], communication_id: params[:communication_id], user_id: params[:user_id])
                            else 
                              nil
                            end
                          end

  end


  if !Rails.env.production?
    
    def session_data 
      render plain: session.inspect.to_s
    end 
    
    def session_clear
      session[:shopping_cart]  = {}
      session["shopping_cart"] = {}
      session[:campaign_id]    = nil
      
      render plain: "OK"
    end
    
    def calendar_test 
    end
    
  end

end
