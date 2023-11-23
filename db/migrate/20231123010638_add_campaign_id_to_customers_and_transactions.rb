class AddCampaignIdToCustomersAndTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :users,        :campaign_id, :integer
    add_column :transactions, :campaign_id, :integer
    
    add_index :users, :campaign_id
    add_index :transactions, :campaign_id
  end
end
