require 'watir'

# Load rails
require File.join(__dir__,'../config/environment.rb')
include Rails.application.routes.url_helpers

# update chromedriver: https://chromedriver.chromium.org/downloads
# https://googlechromelabs.github.io/chrome-for-testing/

class ISBaseWatir
  
  def initialize 
    if !Rails.env.test? # Must be run in Test environment
      Kernel.abort("Tests must be run with RAILS_ENV=test")
    end
    
    @base_url     = "http://localhost:3000"
    
    setup_for_tests
    
    @browser  = Watir::Browser.new
    
    go_home
    
    header "Watir Tests are alive!"
  end
  
  def setup_for_tests
    @total_tests  = 0
    @total_passed = 0
    @total_failed = 0
    destroy_test_data!
  end
  
  def test_user 
    { 
      email: "test@internetschminternet.com",
      first_name: "first",
      last_name: "last",
      role: "customer",
      password: "password1234!"
    }
  end 

  def test_user2 
    { 
      email: "test2@internetschminternet.com",
      first_name: "first 2",
      last_name: "last 2",
      role: "customer",
      password: "password1234!"
    }
  end 
  
  def fill_in_user_sign_up_form!
    
    set_text_field('user_email',      test_user[:email])
    
    set_text_field('user_first_name', test_user[:first_name])

    set_text_field('user_last_name',  test_user[:last_name])

    set_text_field('user_password',   test_user[:password])

    set_text_field('user_password_confirmation', test_user[:password])
    
    click_button "sign_up_button"
    
    sleep 1
  end
  
  def fill_in_user_2fa!
    user = test_user_db
    
    string = "#{user.one_time_code}"
    
    case string.length == 6 
    when true  then good("One time code is 6 digits")
    when false then good("One time code is not 6 digits")
    end
    
    set_text_field('digit_1', string[0])
    set_text_field('digit_2', string[1])
    set_text_field('digit_3', string[2])
    set_text_field('digit_4', string[3])
    set_text_field('digit_5', string[4])
    set_text_field('digit_6', string[5])

    sleep 1
  end
  
  def test_user_record 
    test_user_db
  end 
  
  def destroy_test_user!
    test_user_db.destroy
  end
  
  def test_user_db
    User.find_by(email: test_user[:email])
  end
  
  def create_and_confirm_test_user!
    u = User.new
    u.email      = test_user[:email]
    u.first_name = test_user[:first_name]
    u.last_name  = test_user[:last_name]
    # u.role = test_user[:role]  # role will default to customer
    u.password   = test_user[:password]
    u.password_confirmation  = test_user[:password]
    u.skip_confirmation!
    u.save     
  end
  
  def create_and_confirm_admin_user! 
    create_and_confirm_test_user!
    make_test_user_admin!
  end
  
  def make_test_user_admin! 
    u = User.find_by(email: test_user[:email])
    u.role_admin!
  end
  
  def test_product 
    {
      name: "Test product",
      sku: "12345",
      price_in_cents: 2000,
      purchase_type: "purchase",
      billing_type: "once_off",
      teaser: "Teaser",
      description: "Description",
      for_sale: true
    }
  end 

  def test_subscription
    {
      name: "Test subscription",
      sku: "12345sub",
      price_in_cents: 2000,
      purchase_type: "subscription",
      billing_type: "monthly",
      teaser: "Teaser subscription",
      description: "Description subscription",
      for_sale: true
    }
  end 
  
  def test_event
    {
       user_id: test_user_db.id,
       event_type: Event::event_types[:meeting],
       name: "test event",
       location: "1 Martin Place, Sydney NSW, Australia",
       video_url: "",
       start_datetime: Time.now + 1.month,
       end_datetime: Time.now + 1.month + 1.hour,
       invitees: []
    }
  end
  
  def test_event_db
    event = Event.find_by(name: "test event")
    event = Event.find_by(name: changed) if event.nil?
    event
  end
  
  def test_terms_and_conditions
    {
      status: "draft",
      content: "Test content"
    }
  end

  def test_terms_and_conditions_db
    TermsAndCondition.last
  end
  
  
  def create_test_product! 
    Product.create(test_product)
  end
  
  def create_test_subscription! 
    Product.create(test_subscription)
  end

  def test_product_record 
    product = Product.find_by(name: test_product[:name])
    product = Product.find_by(name: changed) if product.nil?
    product
  end


  def test_product_subscription_record 
    product = Product.find_by(name: test_subscription[:name])
    product = Product.find_by(name: changed, purchase_type: "subscription") if product.nil?
    product
  end

  def test_subscription_record 
    # Subscription.find_by(name: test_subscription[:name])
    Subscription.last
  end

  def test_channel 
    { name: "test_channel" }
  end
  
  def test_channel_record 
    channel = Channel.find_by(name: test_channel[:name])
    channel = Channel.find_by(name: changed) if channel.nil?
    channel
  end
  
  def test_campaign 
    { name: "test_campaign" }
  end
  
  def test_campaign_record 
    # campaign = Campaign.find_by(name: test_campaign[:name])
    # campaign = Campaign.find_by(name: changed) if campaign.nil?
    # campaign
    Campaign.last
  end
  
  def test_communication 
    {
      name: "Test communication",
      communication_type: "email",
      layout: "marketing",
      lifecycle: "pre_sales",
      subject: "Test subject",
      preview: "Test preview",
      content: "Test content"
    }
  end
  
  def test_communication_record 
    communication = Communication.find_by(name: test_communication[:name])
    communication = Communication.find_by(name: changed) if communication.nil?
    communication
  end
  
  def test_time_zone
    'America/Phoenix'
  end
  
  def changed 
    "changed"
  end

  #
  #
  # 
  
  def test_runner 
  end
  
  def get_test_user
    User.find_by(email: test_user[:email])
  end
  
  def destroy_test_user!
    User.where(email: test_user[:email]).destroy_all
  end
    
  def destroy_test_data! 
    User.where(email: test_user[:email]).destroy_all
  end
  
  def remove_session!
    header("Remove Session")
    return if @browser.nil? 
    
    goto "#{@base_url}/set_for_testing"
    wait_for_text 'Empty'
  end 
  
  
  def browse_to(url)
    goto url  
  end 
  
  def go_home
    goto @base_url
  end

  def go_dashboard
    goto "#{@base_url}/dashboard/dashboard"
  end

  def scroll_to_top(time_to_wait = 1)
    @browser.scroll.to :top
    sleep time_to_wait
  end
  
  def scroll_to_bottom(time_to_wait = 1)
    @browser.scroll.to :bottom
    sleep time_to_wait
  end
  
  def wait_for_text(text)
    @browser.wait_until { @browser.text.include? text }
    good("Found in browser: #{text}")
  end
  
  def click(link)
    link = @browser.link(href: link)
    link.click
  end
  
  def click_button(id)
    @browser.button(id: id).click
  end
  
  def set_text_field(id, value)
    # @browser.text_field(id: id).value = value
    text_field = @browser.text_field(id: id)
    text_field.focus
    text_field.value = value
  end
  
  def set_select(id, value)
    select = @browser.select(id: id)
    select.focus()
    select.select(value:value)
  end
  
  def set_datetime_field(id, datetime)
    datetime_field = @browser.date_time_field(id: id)
    datetime_field.focus
    datetime_field.set(datetime.strftime("%Y-%m-%dT%H:%M:%S"))
  end
  
  def execute_javascript(script)
    @browser.execute_script(script)
  end
  
  def good(message) 
    @total_passed += 1
    p "  👍: #{message}"
  end
  
  def bad(message)
    @total_failed += 1
    p "  🍄: #{message}"
  end
  
  def alert_ok
    @browser.alert.ok
  end

  def alert_cancel
    @browser.alert.cancel
  end
  
  def goto(url)
    @browser.goto url
  end
  
  def goto_admin_dashboard 
    goto "#{@base_url}/admin/dashboard"
  end
  
  def header_image_url_subscriber(image)
    "#{@base_url}/image_s/#{image}"
  end
  
  def header_image_url_user(image)
    "#{@base_url}/image_u/#{image}"
  end
  
  def goto_session_data
    goto "#{@base_url}/session_data"
  end

  def goto_session_clear
    goto "#{@base_url}/session_clear"
  end
  
  def header(message)
    p ""
    p "=========================================="
    p "👊 #{message}"
    p "=========================================="
  end
  
  def tests_complete 
    p ""
    p "=========================================="
    p "✅ Tests Complete"
    p "=========================================="
    p "Total tests: #{@total_passed + @total_failed}"
    p "👍: Passed: #{@total_passed}"
    p "🍄: Failed: #{@total_failed}"
    p "------------------------------------------"
    p ""
  end
  
  def sign_up 
    header("User sign up")
    
    click '/users/sign_up'
    
    sleep 1

    # DO NOT USER HELPER FOR THIS H2 wait
    @browser.wait_until { @browser.h2.text == 'Sign up' }
    
    good("Reached Sign up page")
    
    fill_in_user_sign_up_form!
          
    fill_in_user_2fa! 
    
    wait_for_text 'Log Out'
    
    sleep 1
    
    user = test_user_record
    case !user.stripe_customer_id.nil?
    when true  then good("Stripe user create callback created stripe_customer_id")
    when false then bad("Stripe user create callback did not creat stripe_customer_id")
    end
    
    click_button "log_out_button"

    wait_for_text 'Signed out successfully'
  end
  
  
  def sign_in_admin
    go_home 
    
    header("Admin user sign in")
    
    @admin = get_test_user

    case @admin.role_admin? 
    when true  then good("Admin user created successfully")
    when false then bad("Admin user not created successfully")
    end
    
    click '/users/sign_in'
    
    @browser.wait_until { @browser.h2.text == 'Log in' }
    
    set_text_field('user_email', test_user[:email])
    
    set_text_field('user_password', test_user[:password])
    
    click_button "log_in_button"
    
    wait_for_text 'Admin'
  end
  
  def sign_in_test_user 
    go_home 
    
    header("Sign in test user")
    
    click '/users/sign_in'
    
    @browser.wait_until { @browser.h2.text == 'Log in' }
    
    set_text_field('user_email', test_user[:email])
    
    set_text_field('user_password', test_user[:password])
    
    click_button "log_in_button"
    
    wait_for_text 'Signed in successfully'

    sleep 1
  end
  
  def screenshot!
    @browser.screenshot.save "#{Time.now}.png"
  end

end