class WebhooksController < ApplicationController
  
  def stripe 
    secret = ENV['STRIPE_WEBHOOK_SIGNING_SECRET']
  end 
  
end
