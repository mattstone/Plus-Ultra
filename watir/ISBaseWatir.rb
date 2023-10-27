require 'watir'

# Load rails
require File.join(__dir__,'../config/environment.rb')
include Rails.application.routes.url_helpers

# update chromedriver: https://chromedriver.chromium.org/downloads
# https://googlechromelabs.github.io/chrome-for-testing/

class ISBaseWatir
  
  def initialize 
    @base_url     = "http://localhost:3000"
    
    setup_for_tests
    
    @browser  = Watir::Browser.new
    @browser.goto @base_url
    
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
  
  def destroy_test_data! 
    User.where(email: test_user[:email]).destroy_all
  end
  
  def good(message) 
    @total_passed += 1
    "👍: #{message}"
  end
  
  def bad(message)
    @total_failed += 1
    "🍄: #{message}"
  end
  
  def header(message)
    p "=========================================="
    p "👊 #{message}"
    p "=========================================="
  end
  
  def tests_complete 
    p "=========================================="
    p "✅ Tests Complete"
    p "=========================================="
    p "Total tests: #{@total_passed + @total_failed}"
    p "👍: Passed: #{@total_passed}"
    p "🍄: Failed: #{@total_failed}"
    p "------------------------------------------"
    p ""
  end
  
  def screenshot!
  @browser.screenshot.save "#{Time.now}.png"
end

end