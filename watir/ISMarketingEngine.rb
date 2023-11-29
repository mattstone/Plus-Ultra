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
    BulkEmail.destroy_all 
  end
  
  def setup_for_marketing_engine! 
    channel = Channel.find_by(name: "Newsletters")
    channel.destroy if channel
    
    @newsletter_channel  = Channel.create({name: "Newletters"})
    @newsletter_campaign = @newsletter_channel.campaigns.create({ name: "Monthly", communication_type: "email" })
    
    @newsletter = @newsletter_campaign.communications.new 
    @newsletter.communication_type = "email"
    @newsletter.layout             = "marketing"
    @newsletter.lifecycle          = "newsletter"
    @newsletter.name               = "Monthly Newsletter"
    @newsletter.subject            = "#{ENV['APP_NAME']} Monthly Newsletter"
    @newsletter.save

    channel  = Channel.create({name: "Third Party Redirects"})
    @redirect_campaign = channel.campaigns.create({ name: "Example", communication_type: "redirect", redirect_url: ENV['WHO_AM_I'] })
  end
  
  def channels 
    header("Channels")
    bad("Channel records still exist")  if Channel.count  > 0
    bad("Campaign records still exist") if Campaign.count > 0
    
    click '/admin/channels'
    
    wait_for_text 'Manage Channels'

    click '/admin/channels/new'
    
    wait_for_text 'New channel'
    
    sleep 1

    set_text_field('channel_name', test_channel[:name])

    click_button "channel_form_button"

    wait_for_text 'Channel was successfully created'
    
    sleep 1
    
    channel = test_channel_record

    click "/admin/channels/#{channel.id}/edit"
    
    wait_for_text 'Edit Channel'
    
    set_text_field('channel_name', changed)

    click_button "channel_form_button"
    
    wait_for_text 'Channel was successfully updated'
  end 
  
  def campaigns 
    header("Campaigns")
    
    channel = test_channel_record

    click "/admin/channels/#{channel.id}/campaigns"
    
    wait_for_text 'Manage Campaigns'
    
    click "/admin/channels/#{channel.id}/campaigns/new"

    wait_for_text 'New Campaign'
    
    sleep 1
    
    set_text_field('campaign_name', test_campaign[:name])
    
    click_button "channel_campaign_button"
    
    wait_for_text 'Campaign was successfully created'

    campaign = test_campaign_record
    
    wait_for_text "#{ENV['WHO_AM_I']}?tag=#{campaign.id}"
    
    sleep 1
    
    click "/admin/channels/#{channel.id}/campaigns/#{campaign.id}/edit"

    wait_for_text 'Edit Campaign'
    
    set_text_field('campaign_name', changed)
    
    click_button "channel_campaign_button"

    wait_for_text 'Campaign was successfully updated'

    wait_for_text changed
  end
  
  def communications
    header("Communications")
    
    click '/admin/communications'

    wait_for_text "Manage communications"

     # Create communication    
    click '/admin/communications/new'
    
    wait_for_text "New Communication"

    set_text_field('communication_name', test_communication[:name])

    set_select('communication_lifecycle', test_communication[:lifecycle])
    
    set_select('communication_communication_type', test_communication[:communication_type])

    set_select('communication_layout', test_communication[:layout])
    
    set_text_field('communication_subject',  test_communication[:subject])
    
    execute_javascript("document.getElementById('communication_preview_trix_input_communication').value = '<div>#{test_communication[:preview]}</div>'")

    execute_javascript("document.getElementById('communication_content_trix_input_communication').value = '<div>#{test_communication[:content]}</div>'")

    scroll_to_bottom
    
    click_button "channel_form_button"

    wait_for_text "Communication was successfully created"
    
    sleep 1 
    
    # Edit communication
    communication = test_communication_record
    
    click "/admin/communications/#{communication.id}/edit"

    wait_for_text "Edit Communication"

    set_text_field('communication_name', changed)

    scroll_to_bottom(2)
    
    click_button "channel_form_button"

    wait_for_text "Communication was successfully updated"
    wait_for_text changed
  end
  
  def test_redirect 
    header("test_redirect")
    
    @browser.goto @redirect_campaign.redirection_url
    
    wait_for_text "Launching soon!"
    good("Redirection to #{@redirect_campaign.redirection_url} successfull")
  end
  
  def test_newsletter_email 
    header("test_newsletter_email")
    
    goto_admin_dashboard
    
    # Set Campaign to bulk email 
    
    click "/admin/channels"
    
    click "/admin/channels/#{@newsletter_channel.id}/campaigns"
    
    click "/admin/channels/#{@newsletter_channel.id}/campaigns/#{@newsletter_campaign.id}/edit"
    
    set_select('campaign_communication_type', "bulk_email")

    scroll_to_bottom 
    
    click_button "channel_campaign_button"
    good("updated campaign to bulk email")
    
    # Set Communication to newsletter campaign
    
    click "/admin/communications"
    
    communication = test_communication_record
    
    click "/admin/communications/#{communication.id}/edit"
    sleep 1
    
    set_select('communication_campaign_id', @newsletter_campaign.id)

    set_select('communication_layout', 'marketing')

    scroll_to_bottom
    
    click_button 'channel_form_button'
    
    wait_for_text 'Communication was successfully updated'
    wait_for_text 'Marketing'
    good("communication changed to newletter campaign")
    
    # Create bulk email
    click "/admin/bulk_emails"
    
    sleep 1
    
    click "/admin/bulk_emails/new"
    
    wait_for_text "New bulk email"
    
    sleep 1
    
    click_button "bulk_email_submit"

    sleep 1
    
    wait_for_text "Bulk email was successfully created"
    
    bulk_email = BulkEmail.last # This will be the one we just created
    
    click_button "bulk_email_#{bulk_email.id}_send"
    
    case @browser.alert.exists?
    when true  then good("Are you sure? prompt for Send bulk email")
    when false then bad("no Are you sure? prompt for Send bulk email")
    end

    sleep 1
    
    alert_ok
    
    sleep 4 # Give sidekiq enough time to do it's thing
    # 
    click '/admin/bulk_emails'
    
    wait_for_text 'UTC'
    
    good 'Newsletter sent'
    
    communication_sent = CommunicationSent.last 
    
    case !communication_sent.nil?
    when true  then good("CommunicationSent created")
    when false then bad("CommunicationSent not created")
    end

    case !communication_sent.subscriber_id.nil?
    when true  then good("CommunicationSent subscriber valid")
    when false then bad("CommunicationSent subscriber not valid")
    end
      
    # check tracking - opens & click
    
    # check unsubscribe works for subscribers and users (marketing emails)
    
  end
  
  def test_operational_email 
    header("test_operational_email")
  end
  
  def test_marketing_emaail
    header("test_marketing_emaail")
  end

end

ISMarketingEngine.new
