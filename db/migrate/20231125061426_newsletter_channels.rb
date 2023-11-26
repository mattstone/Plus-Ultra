class NewsletterChannels < ActiveRecord::Migration[7.0]
  def change
    channel = Channel.find_by(name: "Newsletters")
    channel.destroy if channel
    
    channel  = Channel.create({name: "Newletters"})
    campaign = channel.campaigns.create({ name: "Monthly", communication_type: "email" })
    
    communication = campaign.communications.new 
    communication.communication_type = "bulk_email"
    communication.layout             = "marketing"
    communication.lifecycle          = "newsletter"
    communication.name               = "Monthly Newsletter"
    communication.subject            = "#{ENV['APP_NAME']} Monthly Newsletter"
    communication.save

    channel  = Channel.create({name: "Third Party Redirects"})
    campaign = channel.campaigns.create({ name: "Example", communication_type: "redirect", redirect_url: ENV['who_am_i'] })
  end
end
