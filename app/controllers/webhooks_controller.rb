class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token # disable CSRF token checking
  
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
