class Subscription < ApplicationRecord
  belongs_to :user 
  belongs_to :product 
  belongs_to :order
  
  has_many   :transactions
  
  enum :status, { incomplete: 0, incomplete_expired: 1, trialing: 2, active: 3, past_due: 4, canceled: 5, unpaid: 6 }, prefix: true 
  
  def add_to_history!(object)
    self.history << object 
    self.save
  end
  
end
