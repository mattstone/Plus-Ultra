class BulkEmail < ApplicationRecord
  
  validates :mailing_list_id,  presence: true
  validates :communication_id, presence: true

  belongs_to :mailing_list
  belongs_to :communication


  def self.communications_for_select 
    Communication 
      .joins(:campaign) 
      .where({ campaign: { communication_type: "bulk_email" }})
      .all
  end


  def send!
    # TODO - use Mailgun bult emails sending (was causing problems)
    
    count = 0
    
    options = {
      communication: self.communication
    }
    
    self.mailing_list.subscribers
    .find_in_batches(batch_size: 20).each do |subscribers|
      subscribers.each do |sub|
        options[:to] = sub.email
        # TODO: send emails
        # TODO: write campaign_sent record
        count += 1
      end
    end
    
    self.datetime_sent = Time.now 
    self.sent          = count
    self.save
  end
  
end
