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

  def customer_update(customer_id, options)
    Stripe::Customer.update(customer_id, options)
  end
  
  #
  # Customer end
  #

  #
  # Payments start
  #
  
  def payment_intent_create(options)
    payment_intent       = nil
    options[:currency] ||= "AUD"
    options[:payment_method_types] ||= ["card", "au_becs_debit"]

    order       = options[:order]
    transaction = options[:transaction]
    description = "order: OR-#{order.id}"
    
    begin 
      payment_intent = Stripe::PaymentIntent.create({
        amount:      options[:transaction].price_in_cents,
        currency:    options[:currency],
        customer:    options[:stripe_customer_id],
        description: description,
        metadata:   { transaction_id: transaction.id },
        payment_method:       order.user.stripe_payment_method,
        statement_descriptor: description,    
        setup_future_usage:   "off_session",        
      }, { idempotency_key: "order_#{options[:transaction].id}" })
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
  # Payment_method start
  #
  
  def payment_method_attach(payment_method_id, stripe_customer_id)
    Stripe::PaymentMethod.attach(
      payment_method_id,
      { customer: stripe_customer_id}
    )  
  end
  
  #
  # Payment_method end
  #
  

  #
  # Subscriptions start
  #

  def subscription_create(object, idempotency_key = nil)
    case idempotency_key.nil?
    when true  then Stripe::Subscription.create(object)
    when false then Stripe::Subscription.create(object, { idempotency_key: idempotency_key })
    end
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
      # l "#{event.type} #{payment_intent.id} received status of: #{payment_intent.status}"
      
    when 'payment_intent.succeeded'
      payment_intent = event.data.object 
      # l "#{event.type} #{payment_intent.id} received status of: #{payment_intent.status}"

      transaction = Transaction.find(payment_intent["metadata"]["transaction_id"])
      if transaction
        if payment_intent["payment_method"]
          transaction.update_column :stripe_payment_method, payment_intent["payment_method"]
          transaction.user.stripe_create_subscription!({ transaction: transaction }) if transaction.order.subscription?
        end
      end
      
      # stripe_payment_method

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
    when 'payment_intent.canceled'
      object = event.data.object 
      l object.inspect.to_s.red
      
    when 'payment_method.attached'
      # object = event.data.object 
      # l object.inspect.to_s.red
      
    when 'charge.succeeded', 'charge.failed', 'charge.refunded'
      
      payment_intent = event.data.object 
      transaction    = Transaction.find(payment_intent["metadata"]["transaction_id"])
      transaction.history << payment_intent

      case event.type 
      when 'charge.succeeded' then transaction.cleared_funds!
      when 'charge.failed'    then transaction.failed!
      when 'charge.refunded'  then transaction.refunded!
      end
      
      if !payment_intent["payment_method"].blank?
        user = transaction.user 
        if user 
          user.update_column :stripe_payment_method, payment_intent["payment_method"]
          self.payment_method_attach(payment_intent["payment_method"], user.stripe_customer_id)
        end
      end
      
    when 'product.created'
      object = event.data.object
      price  = ISRedis.get(object["id"])

      sleep 1 # Callback comes so fast, db has not yet written record!

      product = Product.find(object.metadata["product_id"])
      product.update_column :stripe_product_id, object["id"]
      product.update_column :stripe_price_id,   price["id"]


    when 'product.updated'
      object  = event.data.object
      product = Product.find(object["metadata"]["product_id"])

      # handle changes in stripe without going into a callback loop
      # Note: update_columns was throwing error
      product.update_column :name,     object["name"]
      product.update_column :for_sale, object["active"]
      product.update_column :stripe_price_id, object["default_price"]
    
    when 'product.deleted'
      object  = event.data.object
      product = Product.find_by(stripe_product_id: object["id"])
      product.update_column :for_sale, false

    when 'price.created'
      object  = event.data.object
      # Stripe sends price.created before product created.
      ISRedis.set_ex(object["product"], object, 60) # Save to redis and expire in 60 seconds

    when 'plan.created'
      object  = event.data.object

    when 'invoice.created' # Do nothing 
      object  = event.data.object
      
      # Record the subscription id
      subscription_id = object["subscription_details"]["metadata"]["subscription_id"]
      subscription    = Subscription.find(subscription_id)
      subscription.update_column :stripe_subscription_id, object["subscription"] if subscription
      
    when 'invoice.finalized'
    when 'invoice.payment_succeeded'
      object       = event.data.object
      subscription = Subscription.find_by(stripe_subscription_id: object["subscription"])
      subscription.status_active! if subscription
      
    when 'customer.subscription.deleted'
      
      object = event.data.object 
      
      if object["metadata"]
        subscription = Subscription.find(object["metadata"["subscription_id"]])
        if subscription 
          subscription.status_canceled!
        end
      end
      
      l object.inspect.to_s 
      
    else 
      l "Unhandled event type: #{event.type}"
      
      begin 
        object = event.data.object
        l object.inspect.to_s.gray
      rescue => e
      end
    end
  end
  
  #
  # Webhook end
  #
  
  def price_list
    Stripe::Price.list()
  end

  if !Rails.env.production?
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
  
end