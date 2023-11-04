class Transaction < ApplicationRecord
  belongs_to :product 
  belongs_to :user 
  
  scope :recently_created, ->  { where(created_at: 1.minutes.ago..DateTime.now) }

  enum status: { pending: 0, failed: 1, cleared_funds: 2, error: 3}
 
end
