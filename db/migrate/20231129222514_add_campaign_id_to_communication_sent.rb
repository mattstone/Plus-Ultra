class AddCampaignIdToCommunicationSent < ActiveRecord::Migration[7.0]
  def change
    add_reference :communication_sents, :campaign, add_index: true, foreign_key: true
  end
  
end
