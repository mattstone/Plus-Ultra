class CampaignColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :campaigns, :redirect_url, :string
    add_column :campaigns, :clicks,       :bigint, default: 0
  end
end
