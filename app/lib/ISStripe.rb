require 'stripe'

class ISStripe < ISBaseLib

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

    order       = options[:order]
    transaction = options[:transaction]
    
    description = "order: OR-#{order.id}"
    begin 
      payment_intent = Stripe::PaymentIntent.create(
        amount: options[:transaction][:price_in_cents],
        currency: options[:currency],
        # payment_method_types: options[:payment_method_types],
        automatic_payment_methods:  { enabled: true },
        customer: options[:stripe_customer_id],
        description: description,
        metadata: { transaction_id: transaction.id },
        # receipt_email: options[:receipt_email],  # Turn on when needed
        statement_descriptor: description,
        # confirm: true,  # Execute payment straight away! - need customers payment details stored
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
  
  

  #
  # Subscriptions start
  #

  def subscription_create(object)
    Stripe::Subscription.list(object)
  end
  
  def subscription_retrieve(subscription_id)
    Stripe::Subscription.retrieve(subscription_id)
  end

  def subscription_update(subscription_id, object)
    Stripe::Subscription.update(subscription_id, object)
  end

  def subscription_resume(subscription_id, object)
    Stripe::Subscription.resume(subscription_id, object)
  end
  
  def subscription_cancel(subscription_id)
    Stripe::Subscription.cancel(subscription_id)
  end
  
  def subscriptions_list(options = {})
    options[:limit] ||= 20
    Stripe::Subscription.list(options)
  end
  
  def subscriptions_search(query)
    Stripe::Subscription.search(query)
  end
  
  # Subscription Items 
  
  def subscription_item_create(object)
    Stripe::SubscriptionItem.create(object)
  end

  def subscription_item_retrieve(subscription_item_id)
    Stripe::SubscriptionItem.retrieve(subscription_item_id)
  end

  def subscription_item_update(subscription_item_id, object)
    Stripe::SubscriptionItem.update(subscription_item_id, object)
  end

  def subscription_item_delete(subscription_item_id)
    Stripe::SubscriptionItem.delete(subscription_item_id)
  end
  
  def subscription_item_list(object)
    Stripe::SubscriptionItem.list(object)
  end 
  
  # Subscription Schedules
  
  def subscription_schedule_create(object) 
    Stripe::SubscriptionSchedule.create(object)
  end

  def subscription_schedule_retrieve(subscription_schedule_id) 
    Stripe::SubscriptionSchedule.retrieve(subscription_schedule_id)
  end

  def subscription_schedule_update(subscription_schedule_id, object) 
    Stripe::SubscriptionSchedule.update(subscription_schedule_id, object)
  end

  def subscription_schedule_cancel(subscription_schedule_id) 
    Stripe::SubscriptionSchedule.cancel(subscription_schedule_id)
  end

  def subscription_schedule_cancel(subscription_schedule_id) 
    Stripe::SubscriptionSchedule.cancel(subscription_schedule_id)
  end

  def subscription_schedule_release(subscription_schedule_id) 
    Stripe::SubscriptionSchedule.release(subscription_schedule_id)
  end
  
  def subscription_schedule_list(object)
    object[:limit] ||= 20
    Stripe::SubscriptionSchedule.list(object)
  end
    
  
  #
  # Subscriptions end
  #
  
  #
  # Products start
  #
  
  def product_list(limit = 20)
    Stripe::Product.list({limit: limit})
  end
  
  def product_create(object)
    Stripe::Product.create(object)
  end
  
  def product_update(product_id, object)
    Stripe::Product.update(product_id, object)
  end 
  
  def product_retrieve(product_id)
    Stripe::Product.retrieve(product_id)
  end
  
  def product_delete(product_id)
    Stripe::Product.delete(product_id)
  end
  
  #
  # Products end
  #
  
  #
  # Prices start
  #

  def price_create(object)
    Stripe::Price.create(object)
  end

  def price_retrieve(price_id)
    Stripe::Price.retrieve(price_id)
  end

  def price_update(price_id, object)
    Stripe::Price.retrieve(price_id, object)
  end

  def price_list(object = {})
    object[:limit] ||= 20
    Stripe::Price.list(object)
  end

  def price_search(query)
    Stripe::Price.search(query)
  end

  #
  # Prices End
  #
  
  
  
  #
  # Webhook start
  #
  
  def handle_webhook(event)
    case event.type 
      
    when 'customer.created'
      object = event.data.object
      user   = User.find_by(email: object.email)
      user.stripe_customer_id = object.id
      user.save
      
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
      when 'charge.succeeded' then transaction.cleared_funds!
      when 'charge.failed'    then transaction.failed!
      when 'charge.refunded'  then transaction.refunded!
      end

    when 'product.created'
      object = event.data.object
      price  = ISRedis.get(object["id"])

      sleep 1 # Callback comes so fast, db has not yet written record!

      product = Product.find(object.metadata["product_id"])
      product.stripe_product_id = object["id"]
      product.stripe_price_id   = price["id"]
      product.save

    when 'product.updated'
      object  = event.data.object
      product = Product.find(object["metadata"]["product_id"])

      # handle changes in stripe without going into a callback loop
      # Note: update_columns was throwing error
      product.update_column :name,     object["name"]
      product.update_column :for_sale, object["active"]
      product.update_column :stripe_price_id, object["default_price"]

    when 'price.created'
      object  = event.data.object
      # Stripe sends price.created before product created.
      ISRedis.set_ex(object["product"], object, 60) # Save to redis and expire in 60 seconds
    else 
      l "Unhandled event type: #{event.type}"
    end
  end
  
  #
  # Webhook end
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