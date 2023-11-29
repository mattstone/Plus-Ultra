class CommunicationSent < ApplicationRecord
  belongs_to :communication
  belongs_to :user,       optional: true 
  belongs_to :subscriber, optional: true
  
  def add_one_to_opens!(ip_address)
    self.opens += 1
    self.history << { type: "open", datetime: Time.now, ip_address: ip_address }
  end

  def add_one_to_clicks!(ip_address)
    self.clicks += 1
    self.history << { type: "click", datetime: Time.now, ip_address: ip_address }
  end

end
