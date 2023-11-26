class BulkEmail < ApplicationRecord
  
  validates :mailing_list_id,  presence: true
  validates :communication_id, presence: true

  belongs_to :communication


  def self.communications_for_select 
    Communication 
      .joins(:campaign) 
      .where({ campaign: { communication_type: "bulk_email" }})
      .all
  end

  
end
