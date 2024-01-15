class AddCampaignIdToUser < ActiveRecord::Migration[7.0]
  def change
    # add_reference :users, :campaign, add_index: true, foreign_key: true
    add_index users
  end
end
