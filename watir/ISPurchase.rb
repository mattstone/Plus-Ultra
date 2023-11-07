require File.join(__dir__, "./ISBaseWatir.rb")

class ISPurchase < ISBaseWatir

  # Issues in test mode 
  
  # Stripe iframe does not confirm to Watir standards so manual input required 
  
  # Webhook in test mode is not recieving callback

  def initialize
    super
    remove_test_data!
    create_test_product!
    check_products_exists_to_purchase

    if @total_failed == 0
      not_logged_in 
      
      logged_in
    end
    
  end 
  
  def check_products_exists_to_purchase
    if Product.where(for_sale: true).count == 0 
      bad("No products for sale")
    end
  end
  
  def remove_test_data!
    Transaction.destroy_all 
    ProductOrder.destroy_all
    Order.destroy_all
    destroy_test_user!
    
    remove_session!
  end

  
  def not_logged_in 
        
    link = @browser.link(href: '/products')
    link.click
    sleep 3 # Wait for image to load
    
    good("browsed to /products")
    @browser.scroll.to :bottom
    sleep 1  

    good("scroll_to_bottom")
    
    product = test_product_record
    @browser.button(:id => "add_to_cart_#{product.id}").click
    good("clicked on Add to Cart")

    @browser.scroll.to :top
    sleep 1  
    
    @browser.wait_until { @browser.text.include? 'Checkout' }
    good("product #{product.name} added to cart")
    
    link = @browser.link(href: '/checkout')
    link.click
    
    @browser.wait_until { @browser.text.include? 'Order Summary' }
    good("checkout link clicked")

    sleep 1
    
    @browser.button(:id => "checkout_continue").click
    good("clicked on Add to Cart")

    sleep 1
    
    @browser.wait_until { @browser.text.include? 'Please create an account to continue your order' }
    good("user signup form presented")
    
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
    
    
    @browser.wait_until { @browser.text.include? 'Pending' }
    good("Stripe payment request pending")
    
    # @browser.wait_until { @browser.text.include? 'Cleared funds' }
    # good("Stripe payment request successful")
    
  end 
  
  def logged_in 
    
    link = @browser.link(href: '/products')
    link.click

    @browser.scroll.to :bottom
    sleep 1  

    good("scroll_to_bottom")
    
    product = test_product_record
    @browser.button(:id => "add_to_cart_#{product.id}").click
    good("clicked on Add to Cart")

    @browser.scroll.to :top
    sleep 1  
    
    @browser.wait_until { @browser.text.include? 'Checkout' }
    good("product #{product.name} added to cart")
    
    link = @browser.link(href: '/checkout')
    link.click
    
    @browser.wait_until { @browser.text.include? 'Order Summary' }
    good("checkout link clicked")

    sleep 1
    
    @browser.button(:id => "pay_now").click
    good("clicked on Pay Now")

    good("clicked on Pay Now")
    
    sleep 2

    p "Manually input test credit card details!"
        
    @browser.wait_until { @browser.text.include? 'Pending' }
    good("Stripe payment request pending")
  end
  
end

ISPurchase.new



# <iframe name="__privateStripeMetricsController9570" frameborder="0" allowtransparency="true" scrolling="no" role="presentation" allow="payment *" src="https://js.stripe.com/v3/m-outer-27c67c0d52761104439bb051c7856ab1.html#url=http%3A%2F%2Flocalhost%3A3000%2Fset_for_testing&amp;title=Starter&amp;referrer=&amp;muid=NA&amp;sid=NA&amp;version=6&amp;preview=false" aria-hidden="true" tabindex="-1" style="border: none !important; margin: 0px !important; padding: 0px !important; width: 1px !important; min-width: 100% !important; overflow: hidden !important; display: block !important; visibility: hidden !important; position: fixed !important; height: 1px !important; pointer-events: none !important; user-select: none !important;"></iframe>
