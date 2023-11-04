require 'stripe'

class ISStripe 

  def initialize 
    Stripe.api_key    = ENV["STRIPE_SECRET_KEY"]
  end

  def customer(stipe_customer_id)
    Stripe::Customer.retrieve('stipe_customer_id')
  end
  
  def customers(options = {})
    Stripe::Customer.list()
  end

  def test_card 
    {
    expiry: Time.now + 2.years,
    number: "4242424242424242",
    cvv: "123"
    }
  end
end