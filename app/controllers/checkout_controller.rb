class CheckoutController < ApplicationController
  before_action :authenticate_user!, only: %i[ pay_now ]

  def index 
    if params[:product_id]
      # If subscritption, clear cart and away we go
      @product = Product.find(params[:product_id])
      
      clear_shopping_cart
      add_product_to_shopping_cart(@product, true)
      set_shopping_cart
    end

    if @shopping_cart.count == 0
      @error = "Cart is empty!"
    end
  end 
  
  def checkout_create_account 
    @user = User.new
  end
  
  def pay_now 
    @order       = Order::create_from_shopping_cart(current_user, @shopping_cart)
    @transaction = @order.transactions.first
  end 
  
  def checkout_subscribe 
    @product     = Product.find(params[:product_id])
    @order       = Order::create_for_subscription!(current_user, options)
    @transaction = @order.transactions.first    
  end
  
end
