require 'stripe'

class ISStripe 

  def initialize 
    Stripe.api_key    = ENV["STRIPE_SECRET_KEY"]
  end

  #
  # Customer start
  #
  
  def customer(stipe_customer_id)
    Stripe::Customer.retrieve('stipe_customer_id')
  end
  
  def customers(options = {})
    Stripe::Customer.list()
  end
  
  def customer_create(options)
    Stripe::Customer.create({ email: options[:email] })
  end
  
  #
  # Customer end
  #

  #
  # Payments start
  #
  
  def payment_intent(options)
    payment_intent       = nil
    options[:currency] ||= "AUD"
    options[:payment_method_types] ||= ["card", "au_becs_debit"]
    
    product     = options[:product]
    transaction = options[:transaction]
    
    begin 
      payment_intent = Stripe::PaymentIntent.create(
        amount: options[:transaction][:price_in_cents],
        currency: options[:currency],
        # payment_method_types: options[:payment_method_types],
        automatic_payment_methods:  { enabled: true },
        customer: options[:stripe_customer_id],
        description: product.name,
        metadata: { transaction_id: transaction.id },
        # receipt_email: options[:receipt_email],  # Turn on when needed
        statement_descriptor: product.name,
        # confirm: true,  # Execute payment straight away!
        # off_session: true        
      )
    rescue Stripe::StripeError => e 
      return { error: e.message }
    rescue => e
      return { error: e.message }
    end
    
    payment_intent
  end

  def payment_intent_retrieve(payment_intent_id)
    Stripe::PaymentIntent.retrieve(payment_intent_id)
  end

  def payment_intent_update(payment_intent_id, options)
    Stripe::PaymentIntent.update(payment_intent_id, options)
  end

  def payment_intent_confirm(payment_intent_id, options)
    Stripe::PaymentIntent.confirm(payment_intent_id, options)
  end

  def payment_intent_capture(payment_intent_id)
    # Capture the funds of an existing uncaptured PaymentIntent when its status is requires_capture.
    Stripe::PaymentIntent.capture(payment_intent_id)
  end

  def payment_intent_cancel(payment_intent_id)
    Stripe::PaymentIntent.cancel(payment_intent_id)
  end

  def payment_intent_increment_authorization(payment_intent_id, amount)
    Stripe::PaymentIntent.increment_authorization(payment_intent_id, { amount: amount })
  end

  #
  # Payments end
  #
  
  def price_list
    Stripe::Price.list()
  end

  def test_card 
    {
      expiry: Time.now + 2.years,
      number: "4242424242424242",
      cvv: "123"
    }
  end
  
  def test_card_declined
    {
      expiry: Time.now + 2.years,
      number: "4000000000000002",
      cvv: "123"
    }
  end

  def test_card_insufficient_funds
    {
      expiry: Time.now + 2.years,
      number: "4000000000009995",
      cvv: "123"
    }
  end

  def test_card_lost
    {
      expiry: Time.now + 2.years,
      number: "4000000000009987",
      cvv: "123"
    }
  end

  def test_card_stolen
    {
      expiry: Time.now + 2.years,
      number: "4000000000009979",
      cvv: "123"
    }
  end

  def test_card_expired
    {
      expiry: Time.now + 2.years,
      number: "4000000000000069",
      cvv: "123"
    }
  end
  
end