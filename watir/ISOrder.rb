require File.join(__dir__, "./ISBaseWatir.rb")

class ISOrder < ISBaseWatir
  
  def initialize 
    super
    
    setup_for_tests
    create_test_order!
    
    test_runner

    tests_complete
  end
  
  def setup_for_tests 
    super 
    
    create_and_confirm_test_user!
    create_and_confirm_admin_user!
  end 
  
  def destroy_test_data! 
    super
    
    Transaction.destroy_all
    ProductOrder.destroy_all 
    Order.destroy_all
    
  end
  
  # def test_order(product)
  #   {
  #   amount_in_cents: 0
  #   #<Order:0x000000011ca0e778 id: nil, amount_in_cents: nil, created_at: nil, updated_at: nil, user_id: nil>
  #   }
  # end
  
  def create_test_order!
    create_test_product!
    
    user    = test_user_record
    product = test_product_record 
    
    @order = user.orders.new
    @order.amount_in_cents = 0
    @order.save 
    
    total = 0
    
    @product_order = @order.product_orders.new 
    @product_order.product_id = product.id
    @product_order.quantity   = 1
    @product_order.price_in_cents  = product.price_in_cents 
    @product_order.amount_in_cents = product.price_in_cents * @product_order.quantity
    @product_order.save 
    
    @order.amount_in_cents = @product_order.amount_in_cents
    @order.save 
    
    @transaction = @order.transactions.new 
    @transaction.user_id = user.id
    @transaction.price_in_cents = @order.amount_in_cents 
    @transaction.save
    @transaction.status_cleared_funds!
  end
  
  def test_runner
    header("Create Product")
    sign_in_admin
    
    link = @browser.link(href: '/admin/orders')
    link.click
    
    wait_for_text 'Orders'

    link = @browser.link(href: "/admin/orders/#{@order.id}")
    link.click
    
    wait_for_text 'Order Summary'
  end
  
end

ISOrder.new
