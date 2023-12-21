class OperationalChannelsAndCampaigns < ActiveRecord::Migration[7.0]
  def change
    
    channel  = Channel.find_by(name: "Operational Communications")
    
    
    if channel 
      campaign = channel.campaigns.create({ name: "Signup", communication_type: "email" }) 
      campaign.save
      
      communication = campaign.communications.new 
      communication.name      = "Sign up 2FA Authentication"
      communication.communication_type      = "email"
      communication.layout    = "operations"
      communication.lifecycle = "customer_aquisition"
      communication.subject   = "Your #{ENV['DOMAIN']} verification code"
      communication.preview   = "#{ENV['APP_NAME']} verification code"
      communication.content   = "<p>
        Hello,
      </p>

      <br>

      <p>
        This is your verification code: %2FA_CODE%
      </p>

      <br>"
      communication.save
    end
  end
end
