class CheckoutController < ApplicationController
  before_action :authenticate_user!, only: %i[ pay_now ]

  def index 
    
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
  
end
