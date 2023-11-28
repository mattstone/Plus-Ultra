require File.join(__dir__, "./ISBaseWatir.rb")

class ISPurchase < ISBaseWatir

  # Issues in test mode 
  
  # Stripe iframe does not confirm to Watir standards so manual input required 
  
  # Webhook in test mode is not recieving callback

  def initialize
    super
    
    destroy_test_data!
    create_test_product!
    check_products_exists_to_purchase

    # if @total_failed == 0
    #   not_logged_in 
    #   logged_in
    # 
    #   manage_product
    # end
    

    if @total_failed == 0 
      destroy_test_data!
      create_test_subscription!
      not_logged_in_subscription
      
      manage_subscriptions
    end
    
    
    
    
    tests_complete
  end 
  
  def check_products_exists_to_purchase
    if Product.where(for_sale: true).count == 0 
      bad("No products for sale")
    end
  end
  
  def destroy_test_data!
    super 
    
    Transaction.destroy_all 
    ProductOrder.destroy_all
    Order.destroy_all
    Product.destroy_all
    Subscription.destroy_all
    destroy_test_user!
    
    remove_session!
  end

  
  def not_logged_in 
    header("Product - not logged in")
        
    link = @browser.link(href: '/products')
    link.click
    sleep 3 # Wait for image to load
    
    good("browsed to /products")

    scroll_to_bottom
    
    good("scroll_to_bottom")
    
    product = test_product_record
    @browser.button(:id => "add_to_cart_#{product.id}").click
    good("clicked on Add to Cart")

    scroll_to_top
    
    wait_for_text 'Checkout'
    
    link = @browser.link(href: '/checkout')
    link.click
    
    wait_for_text 'Order Summary'

    sleep 1
    
    @browser.button(:id => "checkout_continue").click
    good("clicked on Add to Cart")

    sleep 1
    
    wait_for_text 'Please create an account to continue your order'
    
    # Create user
    fill_in_user_sign_up_form!

    fill_in_user_2fa!
    good("2fa completed")
    sleep 1
    
    # @browser.wait_until { @browser.text.include? 'Pay Now' }
    good("user signup form completed")
    
    # sleep 1

    @browser.button(:id => "pay_now").click
    good("clicked on Pay Now")
    
    sleep 2

    p "Manually input test credit card details!"
    
    wait_for_text 'Pending'
    
    # @browser.wait_until { @browser.text.include? 'Cleared funds' }
    # good("Stripe payment request successful")
    
  end 
  
  def logged_in 
    header("Product - logged in")
    
    link = @browser.link(href: '/products')
    link.click

    scroll_to_bottom
    good("scroll_to_bottom")
    
    product = test_product_record
    @browser.button(:id => "add_to_cart_#{product.id}").click
    good("clicked on Add to Cart")

    scroll_to_top
    
    wait_for_text 'Checkout'
    
    link = @browser.link(href: '/checkout')
    link.click
    
    wait_for_text 'Order Summary'

    sleep 1
    
    @browser.button(:id => "pay_now").click
    good("clicked on Pay Now")

    sleep 2

    p "Manually input test credit card details!"
        
    wait_for_text 'Pending'
  end
  
  def manage_product 
    header("Manage Product")
    
    go_dashboard
    @browser.wait_until { @browser.text.include? 'Account' }
    good("Browsed to user dashboard")
    
    link = @browser.link(href: '/dashboard/products')
    link.click

    wait_for_text 'My Products'
    wait_for_text test_product[:name]
  end
  
  #
  # Subscription 
  # 
  
  def not_logged_in_subscription
    header("Subscription - not logged in")
    
    sleep 2 
    
    test_product_subscription = test_product_subscription_record
    
    case !test_product_subscription.stripe_product_id.blank?
    when true  then good("product.stripe_product_id has value")
    when false then good("product.stripe_product_id has no value")
    end

    case !test_product_subscription.stripe_price_id.blank?
    when true  then good("product.stripe_price_id has value")
    when false then good("product.stripe_price_id has no value")
    end
    
    link = @browser.link(href: '/products')
    link.click
    sleep 3 # Wait for image to load
    
    good("browsed to /products")

    scroll_to_bottom

    good("scroll_to_bottom")

    @browser.button(:id => "subscribe_#{test_product_subscription.id}").click
    good("clicked on Subscribe")

    sleep 1  

    scroll_to_top    
    
    @browser.button(:id => "checkout_continue").click
    good("clicked on Add to Cart")

    sleep 1
    
    wait_for_text 'Please create an account to continue your order'
    
    # Create user
    fill_in_user_sign_up_form!
    fill_in_user_2fa!
    good("2fa completed")
    sleep 1
    
    # @browser.wait_until { @browser.text.include? 'Pay Now' }
    good("user signup form completed")
    
    sleep 1

    @browser.button(:id => "pay_now").click
    good("clicked on Pay Now")
    
    sleep 2

    p "Manually input test credit card details!"
    
    wait_for_text 'Pending'
    
    # @browser.wait_until { @browser.text.include? 'Cleared funds' }
    # good("Stripe payment request successful")
    
    sleep 2 
    
    # Check database is setup correctly and stripe integration is all good
    user  = test_user_record
    order = user.orders.last 
    
    case !order.nil?
    when true then good("test user has order created")
    when true then bad("test user order not created")
    end
    
    case order.product_orders.count == 1
    when true then good("product_order created")
    when true then bad("product_order error")
    end
    
    subscription = user.subscriptions.last 
    
    case !subscription.nil?
    when true  then good("subscription created")
    when false then bad("subscription creation error")
    end
    
    # Note: Failure here may indicate that Stripe Webhook Listener is not running
    case subscription.status_active?
    when true  then good("subscription active")
    when false then bad("subscription not active")
    end

    case !subscription.stripe_subscription_id.nil?
    when true  then good("subscription registered with Stripe")
    when false then bad("subscription not registered with Stripe")
    end
    
  end 
  
  def manage_subscriptions
    header("Manage Subscriptions")
    
    go_dashboard
    
    wait_for_text 'Account'

    link = @browser.link(href: '/dashboard/subscriptions')
    link.click
    
    wait_for_text 'My Subscriptions'

    wait_for_text test_subscription[:name]
    
    sleep 4
    
    link = @browser.link(href: '/dashboard/subscriptions')
    link.click
    
    wait_for_text 'My Subscriptions'
    wait_for_text 'Active'
    
    good("Subscription active")
    
    subscription = test_subscription_record

    @browser.button(:id => "subscription_#{subscription.id}_cancel").click
    good("clicked cancel subscription")
    
    sleep 2
    
    alert_ok

    wait_for_text 'Canceled'
    
    subscription.reload 
    
    case subscription.status_canceled?
    when true  then good("subscription confirmed canceled")
    when false then bad("subscription not confirmed canceled") 
    end
  end
  
end

ISPurchase.new



# <iframe name="__privateStripeMetricsController9570" frameborder="0" allowtransparency="true" scrolling="no" role="presentation" allow="payment *" src="https://js.stripe.com/v3/m-outer-27c67c0d52761104439bb051c7856ab1.html#url=http%3A%2F%2Flocalhost%3A3000%2Fset_for_testing&amp;title=Starter&amp;referrer=&amp;muid=NA&amp;sid=NA&amp;version=6&amp;preview=false" aria-hidden="true" tabindex="-1" style="border: none !important; margin: 0px !important; padding: 0px !important; width: 1px !important; min-width: 100% !important; overflow: hidden !important; display: block !important; visibility: hidden !important; position: fixed !important; height: 1px !important; pointer-events: none !important; user-select: none !important;"></iframe>
