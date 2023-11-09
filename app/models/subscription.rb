class Subscription < ApplicationRecord
  belongs_to :user 
  belongs_to :product 
  
  has_many   :transactions
  
  enum :status, { pending: 0, active: 1, cancelled_by_customer: 2, cancelled_due_to_billing: 3, retrying_billing: 4, error: 5}, prefix: true 
  
  def add_to_history!(object)
    self.history << object 
    self.save
  end
end
