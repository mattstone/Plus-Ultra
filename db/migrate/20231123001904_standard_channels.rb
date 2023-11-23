class StandardChannels < ActiveRecord::Migration[7.0]
  def change
    
    Channel.destroy_all 

    add_column :campaigns, :communication_type, :integer, default: 0

    
    channel  = Channel.create({ name: "Organic" })
    campaign = channel.campaigns.create({ name: "No referrer" }) 
    campaign = channel.campaigns.create({ name: "Referrer" }) 
    
    channel  = Channel.create({ name: "Search Engine" })
    campaign = channel.campaigns.create({ name: "Organic" }) 
    campaign = channel.campaigns.create({ name: "Paid"    }) 

    channel  = Channel.create({ name: "Operational Communications" })
    campaign = channel.campaigns.create({ name: "Welcome Email", communication_type: 1 }) 
    
  end
end
