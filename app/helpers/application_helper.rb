module ApplicationHelper
  
  def standard_button_class
    "btn btn-sm btn-primary"
  end 
  
  def admin_button_class
    "btn btn-sm btn-primary"
  end
  
  def admin_header_class 
    "text-primary"
  end
  
  def admin_background_class 
    "p-3 mb-2 bg-primary text-white"
  end
  
  def cents_to_dollars(amount_in_cents)
    number_to_currency(amount_in_cents / 100)
  end
    
end
