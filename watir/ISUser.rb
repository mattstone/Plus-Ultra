require File.join(__dir__, "./ISBaseWatir.rb")

class ISUser < ISBaseWatir
  
    def initialize 
      super

      destroy_test_data!
    
      sign_up
      
      sign_in 
      
      create_and_confirm_admin_user!
      
      sign_in_admin_user
      
      tests_complete
    end 
    
    def sign_up 
      header("User sign up")
      link = @browser.link(href: '/users/sign_up')
      link.click
      
      # DO NOT USER HELPER FOR THIS H2 wait
      @browser.wait_until { @browser.h2.text == 'Sign up' }
      good("Reached Sign up page")
      
      fill_in_user_sign_up_form!
            
      fill_in_user_2fa! 
      
      wait_for_text 'Log Out'
      
      sleep 2
      
      user = test_user_record
      case !user.stripe_customer_id.nil?
      when true  then good("Stripe user create callback created stripe_customer_id")
      when false then bad("Stripe user create callback did not creat stripe_customer_id")
      end
      
      @browser.button(:id => "log_out_button").click
      
      wait_for_text 'Signed out successfully'
    end
    
    def sign_in 
      
      sign_in_test_user
      
      @browser.button(:id => "log_out_button").click

      wait_for_text 'Signed out successfully'
    end 
    
    def sign_in_admin_user
      
      sign_in_admin
      
      admin_users_crud
    end
    
    
    def admin_users_crud
      header("Admin user CRUD")

      link = @browser.link(href: '/admin/users')
      link.click

      wait_for_text 'Manage Users'

      wait_for_text test_user[:email]

      text_field = @browser.text_field(id: 'filter_email')
      text_field.value = "zz"

      @browser.button(:id => "users_filter_button").click
      
      wait_for_text "There are no users"

      text_field = @browser.text_field(id: 'filter_email')
      text_field.value = ""

      @browser.button(:id => "users_filter_button").click
      
      wait_for_text test_user[:email]
      
      user = get_test_user
      link = @browser.link(href: "/admin/users/#{user.id}/edit")
      link.click
      
      wait_for_text "Edit User"

      scroll_to_bottom

      text_field = @browser.text_field(id: 'user_first_name')
      text_field.value = changed

      dropdown = @browser.select(id: 'user_time_zone')
      dropdown.select(value: test_time_zone)

      @browser.button(:id => "admin_users_update_button").click

      wait_for_text "successfully updated"
      
      link = @browser.link(href: "/admin/users")
      link.click

      wait_for_text "Manage Users"
      
      wait_for_text changed.capitalize
      
      link = @browser.link(href: "/admin/users/#{user.id}/edit")
      link.click
      
      wait_for_text "Edit User"
      
      scroll_to_bottom

      wait_for_text test_time_zone
    end
  
end

ISUser.new