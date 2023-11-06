class CheckoutController < ApplicationController
  
  def index 
    
    if @shopping_cart.count == 0
      @error = "Cart is empty!"
    else 
      # create order from cart
    end 
  end 
  
  def checkout_create_account 
    @user = User.new
  end
  
end
