require 'stripe'

class ISStripe 

  def initialize 
    Stripe.api_key    = ENV["STRIPE_API_KEY"]
    Stripe.secret_key = ENV["STRIPE_SECRET_KEY"]
  end


  def test_card 
    {
    expiry: Time.now + 2.years,
    number: "4242424242424242".
    cvv: "123"
    }
  end
end