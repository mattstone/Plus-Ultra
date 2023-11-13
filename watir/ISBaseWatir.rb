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
  
  def fill_in_user_sign_up_form!
    text_field = @browser.text_field(id: 'user_email')
    text_field.value = test_user[:email]
    
    text_field = @browser.text_field(id: 'user_first_name')
    text_field.value = test_user[:first_name]

    text_field = @browser.text_field(id: 'user_last_name')
    text_field.value = test_user[:last_name]

    text_field = @browser.text_field(id: 'user_password')
    text_field.value = test_user[:password]

    text_field = @browser.text_field(id: 'user_password_confirmation')
    text_field.value = test_user[:password]
    
    @browser.button(:id => "sign_up_button").click
    sleep 1
  end
  
  def fill_in_user_2fa!
    user = test_user_db
    
    string = "#{user.one_time_code}"
    
    case string.length == 6 
    when true  then good("One time code is 6 digits")
    when false then good("One time code is not 6 digits")
    end
    
    text_field = @browser.text_field(id: 'digit_1')
    text_field.value = string[0]

    text_field = @browser.text_field(id: 'digit_2')
    text_field.value = string[1]

    text_field = @browser.text_field(id: 'digit_3')
    text_field.value = string[2]

    text_field = @browser.text_field(id: 'digit_4')
    text_field.value = string[3]

    text_field = @browser.text_field(id: 'digit_5')
    text_field.value = string[4]

    text_field = @browser.text_field(id: 'digit_6')
    text_field.value = string[5]
    
    sleep 1
  end
  
  def test_user_record 
    test_user_db
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
  
  def create_test_product! 
    Product.create(test_product)
  end

  def test_product_record 
    product = Product.find_by(name: test_product[:name])
    product = Product.find_by(name: "Changed") if product.nil?
    product
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
    @browser.goto "#{@base_url}/set_for_testing"
    @browser.wait_until { @browser.text.include? 'Empty' }
    good("Empty Shopping Cart")
  end 
  

  
  
  def go_home
    @browser.goto @base_url
  end
  
  def good(message) 
    @total_passed += 1
    p "  👍: #{message}"
  end
  
  def bad(message)
    @total_failed += 1
    p "  🍄: #{message}"
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
  
  def sign_in_admin
    go_home 
    
    header("Admin user sign in")
    
    @admin = get_test_user

    case @admin.role_admin? 
    when true  then good("Admin user created successfully")
    when false then bad("Admin user not created successfully")
    end
    
    link = @browser.link(href: '/users/sign_in')
    link.click
    
    @browser.wait_until { @browser.h2.text == 'Log in' }
    
    text_field = @browser.text_field(id: 'user_email')
    text_field.value = test_user[:email]
    
    text_field = @browser.text_field(id: 'user_password')
    text_field.value = test_user[:password]
    
    @browser.button(:id => "log_in_button").click
    
    @browser.wait_until { @browser.text.include? 'Admin' }
    good("Signed in successfully")
  end
  
  
  def screenshot!
    @browser.screenshot.save "#{Time.now}.png"
  end

end