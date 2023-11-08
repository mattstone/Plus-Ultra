class HomeController < ApplicationController
  
  def index 
  end
  
  
  def subscribe_to_newsletter
  end 
  
  
  if !Rails.env.production?
    def set_for_testing 
      clear_shopping_cart
    end
    
    def qr_code 
    end 
    
  end

end
