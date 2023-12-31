class Transaction < ApplicationRecord
  audited
  
  belongs_to :order, touch: true
  belongs_to :user,  touch: true
  belongs_to :subscription, optional: true
  
  belongs_to :campaigns,    optional: true

  broadcasts_refreshes

  scope :recently_created, ->  { where(created_at: 1.minutes.ago..DateTime.now) }

  enum :status, { pending: 0, failed: 1, cleared_funds: 2, error: 3, refunded: 4 }, prefix: true 
 
 
  def failed! 
    self.status_failed!
    # plus any other logic
  end 
  
  def cleared_funds! 
    self.status_cleared_funds!
    # send invoice, etc..
  end
  
  def cleared_funds?
    self.status_cleared_funds?
  end

   def refunded!
     self.status_refunded!
     self.product.refunded!
   end  

  
end
