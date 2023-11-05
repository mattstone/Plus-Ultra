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
    case event.type 
    when 'payment_intent.created'
      payment_intent = event.data.object 
      l "#{event.type} #{payment_intent.id} received status of: #{payment_intent.status}"
    when 'payment_intent.succeeded'
      payment_intent = event.data.object 
      l "#{event.type} #{payment_intent.id} received status of: #{payment_intent.status}"
    when 'payment_intent.attached'
      payment_intent = event.data.object 
      l "#{event.type} #{payment_intent.id} received status of: #{payment_intent.status}"
    when 'payment_intent.failed'
      payment_intent = event.data.object 
      l "#{event.type} #{payment_intent.id} received status of: #{payment_intent.status}"
    when 'payment_intent.processing'
      payment_intent = event.data.object 
      l "#{event.type} #{payment_intent.id} received status of: #{payment_intent.status}"
    when 'payment_intent.requires_action'
      payment_intent = event.data.object 
      l "#{event.type} #{payment_intent.id} received status of: #{payment_intent.status}"
    when 'payment_intent.succeeded'
      payment_intent = event.data.object 
      l "#{event.type} #{payment_intent.id} received status of: #{payment_intent.status}"
      
    when 'charge.succeeded', 'charge.failed', 'charge.refunded'
      payment_intent = event.data.object 
      transaction    = Transaction.find(payment_intent["metadata"]["transaction_id"])
      transaction.history << payment_intent
      
      case event.type 
      when 'charge.succeeded'  
        transaction.status_cleared_funds!
        transaction.product.purchased!
      when 'charge.failed'    then transaction.status_failed!
      when 'charge.refunded'  then transaction.status_refunded!
      end      
      
    else 
      l "Unhandled event type: #{event.type}"
    end
    
    render json: { message: "ok" }, status: 200
  end 
  
    
end
