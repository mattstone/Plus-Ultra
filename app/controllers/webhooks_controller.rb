class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token # disable CSRF token checking
  
  def twilio 
    case params[:SmsStatus]
    when "delivered"
      user = User.find_by(mobile: params[:To].gsub("+", ""))
      
      case user.nil?
      when true # TODO: handle uknown user
      when false 
        if params[:SmsMessageSid] or params[:MessageSid]
          sid = !params[:SmsMessageSid].blank? ? params[:SmsMessageSid] : params[:MessageSid]
          # TODO: find campaign_sent by sid and flag delivered
        end
      end
      
    when "received"
      case params["To"]
      when ENV['TWILIO_MOBILE_NUMBER']
        user = User.find_by(mobile: params[:From].gsub("+", "").gsub("whatsapp:", ""))
        
        case user.nil?
        when true  # TODO: handle message received from unknown user 
        when false # TODO: handle message received from known user
        end
      end

    end

  end
  
  def stripe 
    payload   = request.body.read 
    signature = request.env['HTTP_STRIPE_SIGNATURE']
    event     = nil
    
    begin 
      event = Stripe::Webhook.construct_event(payload, signature, ENV['STRIPE_WEBHOOK_SIGNING_SECRET'])
    rescue JSON::ParseError => e 
      render json: { message: e}, status: 400 and return
    rescue Stripe::SignatureVerificationError => e 
      render json: { message: e}, status: 400 and return
    end

    # If we get here.. all is good!
    
    if !Rails.env.production?
      Rails.logger.info event.type.to_s.red
    end 
    
    stripe = ISStripe.new 
    stripe.handle_webhook(event)
    
    render json: { message: "ok" }, status: 200
  end 

    
end
