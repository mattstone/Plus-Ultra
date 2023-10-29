require File.join(__dir__, "./ISBaseWatir.rb")

class ISUser < ISBaseWatir
  
    def initialize 
      super
    
      sign_up
      sign_in 
      
      destroy_test_data!
      create_and_confirm_admin_user!
      
      sign_in_admin_user
      
      tests_complete
    end 
    
    def sign_up 
      header("User sign up")
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

      u = User.find_by(email: test_user[:email])
      link = "#{@base_url}/users/confirmation?confirmation_token=#{u.confirmation_token}"
      @browser.goto link
      
      good("Reached Confirmation link")
      
    end
    
    def sign_in 
      
      go_home 
      header("User sign in")
      link = @browser.link(href: '/users/sign_in')
      link.click
      
      @browser.wait_until { @browser.h2.text == 'Log in' }
      
      text_field = @browser.text_field(id: 'user_email')
      text_field.value = test_user[:email]
      
      text_field = @browser.text_field(id: 'user_password')
      text_field.value = test_user[:password]
      
      @browser.button(:id => "log_in_button").click
      
      @browser.wait_until { @browser.text.include? 'Signed in successfully' }

      good("Signed in successfully")

      sleep 1
      
      @browser.button(:id => "log_out_button").click


      @browser.wait_until { @browser.text.include? 'Signed out successfully' }

      good("Signed out successfully")
    end 
    
    def sign_in_admin_user
      
      sign_in_admin
      
      admin_users_crud
    end
    
    
    def admin_users_crud
      header("Admin user CRUD")

      link = @browser.link(href: '/admin/users')
      link.click

      @browser.wait_until { @browser.text.include? 'Manage Users' }
      good("browsed to admin/users")

      @browser.wait_until { @browser.text.include? test_user[:email] }
      good("found test user email: #{test_user[:email]}")

      text_field = @browser.text_field(id: 'filter_email')
      text_field.value = "zz"

      @browser.button(:id => "users_filter_button").click
      
      @browser.wait_until { @browser.text.include? "There are no users" }
      good("Filter filtered out #{test_user[:email]}")

      text_field = @browser.text_field(id: 'filter_email')
      text_field.value = ""

      @browser.button(:id => "users_filter_button").click
      @browser.wait_until { @browser.text.include? test_user[:email] }
      good("found test user email: #{test_user[:email]}")
      
      user = get_test_user
      link = @browser.link(href: "/admin/users/#{user.id}/edit")
      link.click
      
      @browser.wait_until { @browser.text.include? "Edit User" }
      good("Editing test user")

      text_field = @browser.text_field(id: 'user_first_name')
      text_field.value = "Changed"

      @browser.button(:id => "admin_users_update_button").click

      @browser.wait_until { @browser.text.include? "successfully updated" }
      good("Edited test user successfully")
      
      link = @browser.link(href: "/admin/users")
      link.click

      @browser.wait_until { @browser.text.include? "Manage Users" }
      good("Back button worked")

      @browser.wait_until { @browser.text.include? "Changed" }
      good("Edit was successful")

    end
  
end

ISUser.new