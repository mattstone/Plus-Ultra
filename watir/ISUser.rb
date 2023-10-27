require File.join(__dir__, "./ISBaseWatir.rb")

class ISUser < ISBaseWatir
  
    def initialize 
      super
    
      sign_up
      tests_complete
    end 
    
    def sign_up 
      header("User signup")
      link = @browser.link(href: '/users/sign_up')
      link.click
      
      @browser.wait_until { @browser.h2.text == 'Sign up' }
      
      good("Reached Sign up page")
      
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
      
      @browser.wait_until { @browser.text.include? 'confirmation link' }
      
      good("Received Confirmation link")


      # A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.
      
      u = User.find_by(email: test_user[:email])
      link = "#{@base_url}/users/confirmation?confirmation_token=#{u.confirmation_token}"
      @browser.goto link
      
      good("Reached Confirmation link")
      
    end
  
end

user = ISUser.new