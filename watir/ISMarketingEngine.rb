require File.join(__dir__, "./ISBaseWatir.rb")

class ISMarketingEngine < ISBaseWatir
  
  def initialize 
    super
    
    remove_test_data!
    create_and_confirm_admin_user!
    
    sign_in_admin
    
    channels
    
    campaigns
    
  end 
  
  def remove_test_data!
    Channel.destroy_all
  end
  
  def channels 
    header("Channels")
    bad("Channel records still exist")  if Channel.count  > 0
    bad("Campaign records still exist") if Campaign.count > 0
    
    link = @browser.link(href: '/admin/channels')
    link.click

    @browser.wait_until { @browser.text.include? 'Manage Channels' }
    good("browsed to admin/channels")

    link = @browser.link(href: '/admin/channels/new')
    link.click
    @browser.wait_until { @browser.text.include? 'New channel' }
    good("browsed to admin/channels/new")

    text_field = @browser.text_field(id: 'channel_name')
    text_field.value = test_channel[:name]

    @browser.button(:id => "channel_form_button").click
    @browser.wait_until { @browser.text.include? 'Channel was successfully created' }
    good("Channel created")
    
    sleep 1
    
    channel = test_channel_record

    link = @browser.link(href: "/admin/channels/#{channel.id}/edit")
    link.click
    @browser.wait_until { @browser.text.include? 'Edit Channel' }
    good("browsed to admin/channels/#{channel.id}/edit")
    
    text_field = @browser.text_field(id: 'channel_name')
    text_field.value = changed
    @browser.button(:id => "channel_form_button").click
    @browser.wait_until { @browser.text.include? 'Channel was successfully updated' }
    good("Channel was successfully updated")
  end 
  
  def campaigns 
    header("Campaigns")
    
    channel = test_channel_record

    link = @browser.link(href: "/admin/channels/#{channel.id}/campaigns")
    link.click
    @browser.wait_until { @browser.text.include? 'Manage Campaigns' }
    good("Browsed to /admin/channels/#{channel.id}/campaigns")
    
    link = @browser.link(href: "/admin/channels/#{channel.id}/campaigns/new")
    link.click
    @browser.wait_until { @browser.text.include? 'New Campaign' }
    good("Browsed to /admin/channels/#{channel.id}/campaigns/new")
    
    sleep 1
    
    good("foo: 1")
    
    text_field = @browser.text_field(id: 'campaign_name')
    text_field.value = test_campaign[:name]
    
    @browser.button(:id => "channel_campaign_button").click
    @browser.wait_until { @browser.text.include? 'Campaign was successfully created' }
    good("Campaign was successfully created")
    
    campaign = test_campaign_record
    @browser.wait_until { @browser.text.include? "#{ENV['WHO_AM_I']}?tag=#{campaign.id}" }
    good("Campaign tag successfully created")
    
    sleep 1
    
    link = @browser.link(href: "/admin/channels/#{channel.id}/campaigns/#{campaign.id}/edit")
    link.click
    @browser.wait_until { @browser.text.include? 'Edit Campaign' }
    good("Browsed to /admin/channels/#{channel.id}/campaigns/#{campaign.id}/edit")
    
    text_field = @browser.text_field(id: 'campaign_name')
    text_field.value = changed
    @browser.button(:id => "channel_campaign_button").click
    @browser.wait_until { @browser.text.include? 'Campaign was successfully updated' }
    good("Campaign was successfully updated")

    @browser.wait_until { @browser.text.include? changed }
    good("Campaign was successfully changed")
  end
  
end

ISMarketingEngine.new
