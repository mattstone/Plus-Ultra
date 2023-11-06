class ProductOrder < ApplicationRecord
  belongs_to :order 
  belongs_to :product 
  
  def total 
    self.quantity * self.amount_in_cents
  end
  
end
