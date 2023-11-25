require File.join(__dir__, "./ISBaseWatir.rb")

class ISMarketingEngine < ISBaseWatir
  
  def initialize 
    super
    
    remove_test_data!
    create_and_confirm_admin_user!
    
    sign_in_admin
    
    channels
    
    campaigns
    
    communications
    
    setup_for_marketing_engine!
    
    test_redirect
    
    test_newsletter_email 
    
    test_operational_email 
    
    test_marketing_emaail
    
  end 
  
  def remove_test_data!
    Channel.destroy_all
    Communication.destroy_all
  end
  
  def setup_for_marketing_engine! 
    channel = Channel.find_by(name: "Newsletters")
    channel.destroy if channel
    
    channel  = Channel.create({name: "Newletters"})
    campaign = channel.campaigns.create({ name: "Monthly", communication_type: "email" })
    
    communication = campaign.communications.new 
    communication.communication_type = "email"
    communication.layout             = "marketing"
    communication.lifecycle          = "newsletter"
    communication.name               = "Monthly Newsletter"
    communication.subject            = "#{ENV['APP_NAME']} Monthly Newsletter"
    communication.save

    channel  = Channel.create({name: "Third Party Redirects"})
    @redirect_campaign = channel.campaigns.create({ name: "Example", communication_type: "redirect", redirect_url: ENV['WHO_AM_I'] })
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
  
  def communications
    header("Communications")
    
    link = @browser.link(href: '/admin/communications')
    link.click
    @browser.wait_until { @browser.text.include? "Manage communications" }
    good("Browsed to /admin/communications")

     # Create communication    
    link = @browser.link(href: '/admin/communications/new')
    link.click
    
    @browser.wait_until { @browser.text.include? "New Communication" }
    good("Browsed to /admin/communications/new")

    text_field = @browser.text_field(id: 'communication_name')
    text_field.value = test_communication[:name]

    dropdown = @browser.select(id: 'communication_lifecycle')
    dropdown.focus
    dropdown.select(value: test_communication[:lifecycle])
    
    dropdown = @browser.select(id: 'communication_communication_type')
    dropdown.focus
    dropdown.select(value: test_communication[:communication_type])

    dropdown = @browser.select(id: 'communication_layout')
    dropdown.focus
    dropdown.select(value: test_communication[:layout])
    
    text_field = @browser.text_field(id: 'communication_subject')
    text_field.focus
    text_field.value = test_communication[:subject]

    javascript_script = "document.getElementById('communication_preview_trix_input_communication').value = '<div>#{test_communication[:preview]}</div>'"
    @browser.execute_script(javascript_script)

    javascript_script = "document.getElementById('communication_content_trix_input_communication').value = '<div>#{test_communication[:content]}</div>'"
    @browser.execute_script(javascript_script)

    @browser.scroll.to :bottom
    sleep 1
    
    @browser.button(:id => "channel_form_button").click

    @browser.wait_until { @browser.text.include? "Communication was successfully created" }
    good("Communication was successfully created")
    
    sleep 1 
    
    # Edit communication
    communication = test_communication_record
    
    link = @browser.link(href: "/admin/communications/#{communication.id}/edit")
    link.click

    @browser.wait_until { @browser.text.include? "Edit Communication" }
    good("Browsed to /admin/communications/#{communication.id}/edit")

    text_field = @browser.text_field(id: 'communication_name')
    text_field.value = changed

    @browser.scroll.to :bottom
    sleep 2
    
    @browser.button(:id => "channel_form_button").click

    @browser.wait_until { @browser.text.include? "Communication was successfully updated" }
    @browser.wait_until { @browser.text.include? "changed" }
    good("Communication was successfully updated")
  end
  
  def test_redirect 
    header("test_redirect")
    
    @browser.goto @redirect_campaign.redirection_url
    @browser.wait_until { @browser.text.include? "Launching soon!" }
    good("Redirection to #{@redirect_campaign.redirection_url} successfull")
    
  end
  
  def test_newsletter_email 
    header("test_newsletter_email")
    
  end
  
  def test_operational_email 
    header("test_operational_email")
  end
  
  def test_marketing_emaail
    header("test_marketing_emaail")
  end

  
end

ISMarketingEngine.new
