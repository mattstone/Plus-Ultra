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
    
    test_newsletter_email # marketing email
    
    test_operational_email 
    
    test_new_user_is_tagged_with_originating_campaign
    
  end 
  
  def remove_test_data!
    CommunicationSent.destroy_all
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

    wait_for_text "Manage Communications"

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
    
    click_button "communication_form_button"

    wait_for_text "Communication was successfully created"
    
    sleep 1 
    
    # Edit communication
    communication = test_communication_record
    
    click "/admin/communications/#{communication.id}/edit"

    wait_for_text "Edit Communication"

    set_text_field('communication_name', changed)

    scroll_to_bottom(2)
    
    click_button "communication_form_button"

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
    
    click_button 'communication_form_button'
    
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

    case communication_sent.user_id.nil?
    when true  then good("CommunicationSent has no user")
    when false then bad("CommunicationSent has no user")
    end

    # Browse header image check tracking - opens & click
    campaign = communication_sent.communication.campaign
    
    goto "#{header_image_url_subscriber("logo")}/#{campaign.id}/#{communication_sent.communication_id}/#{communication_sent.subscriber_id}"

    communication_sent.reload
    
    case communication_sent.opens == 1
    when true  then good("rendering image increments communication_sent.opens")
    when false then bad("rendering image increments communication_sent.opens")
    end

    case communication_sent.history.count == 1
    when true  then good("rendering image appends to communication_sent.history")
    when false then bad("rendering image appends to communication_sent.history")
    end

    # sleep 880
    
    # check unsubscribe works for subscribers and users (marketing emails)
    
  end
  
  def test_operational_email 
    header("test_operational_email")

    # Setup standard email campaign
    channel  = test_channel_record
    campaign = channel.campaigns.last
    
    campaign_name = "Operational Email Test"
    
    goto "#{@base_url}/admin/channels"
    
    wait_for_text "Manage Channels"

    # p "2: channel:  #{channel.inspect}"
    # p "2: campaign: #{campaign.inspect}"
    # 
    click "/admin/channels/#{channel.id}/campaigns"

    wait_for_text "Manage Campaigns"

    click "/admin/channels/#{channel.id}/campaigns/#{campaign.id}/edit"
    
    wait_for_text 'Edit Campaign'
    
    set_text_field('campaign_name', campaign_name)
    
    click_button("channel_campaign_button")
    
    wait_for_text "Campaign was successfully updated"
    
    # Change communication to belong to this campaign
    click "/admin/communications"

    wait_for_text "Manage Communications"
    
    communication = test_communication_record
    
    # p "communication: #{communication.inspect}"

    click "/admin/communications/#{communication.id}/edit"
    
    set_select('communication_campaign_id', "#{campaign.id}")
    
    set_select('communication_layout', "operations")

    scroll_to_bottom
    
    click_button 'communication_form_button'
    
    wait_for_text "Manage Communications"
    
    click_button "communication_send_test_#{communication.id}"
    
    sleep 1
    
    alert_ok
    good("Test email sent")
    
    # Send as normal operational email
    options = {
      communication: communication,
      user: test_user_record
    }
    
    UserMailer::communication(options).deliver_now!
    good("Operational email sent")
    
    sleep 2
    
    case CommunicationSent.count == 2 
    when true  then good("CommunicationSent record created")
    when false then bad("CommunicationSent record not created")
    end
    
    communication_sent = CommunicationSent.last 
    
    case communication_sent.communication_id == communication.id
    when true  then good("CommunicationSent communication_id correct")
    when false then bad("CommunicationSent communication_id is not correct")
    end

    case communication_sent.user_id == test_user_record.id
    when true  then good("CommunicationSent user_id correct")
    when false then bad("CommunicationSent user_id is not correct")
    end
    
    campaign = communication_sent.campaign
    
    goto "#{header_image_url_user("logo")}/#{campaign.id}/#{communication_sent.communication_id}/#{communication_sent.user_id}"

    communication_sent.reload

    case communication_sent.opens == 1
    when true  then good("rendering image increments communication_sent.opens")
    when false then bad("rendering image increments communication_sent.opens")
    end

    case communication_sent.history.count == 1
    when true  then good("rendering image appends to communication_sent.history")
    when false then bad("rendering image appends to communication_sent.history")
    end

  end
  
  def test_new_user_is_tagged_with_originating_campaign

    header("test_new_user_is_tagged_with_originating_campaign")
    
    
    p "test_new_user_is_tagged_with_originating_campaign: 1"

    communication = test_communication_record
    campaign      = communication.campaign 
    
    case !campaign.nil?
    when true  then good("campaign is valid")
    when false then bad("campaign is not valid")
    end
    
    #
    # Now logout and clear any session data
    #

    goto_admin_dashboard
    
    wait_for_text "Admin"

    click_button "admin_sign_out" # Sign out admin
    
    wait_for_text "You have been successfully signed out"

    goto_session_clear

    wait_for_text "OK"
    
    destroy_test_user!
    
    case User.count == 0 
    when true  then good("Test user destroyed")
    when false then bad("Test user not destroyed")
    end

    #
    # Browse to site with tagged url and user created should be tagged with the campaign
    #

    goto "#{@base_url}?tag=#{campaign.id}"
    
    sleep 1

    sign_up
    
    user = test_user_record
    
    case user.campaign_id == campaign.id
    when true  then good("user tagged with correct campaign id: #{campaign.id}")
    when false then bad("user not tagged with correct campaign id: #{campaign.id}")
    end
    
  end

end

ISMarketingEngine.new
