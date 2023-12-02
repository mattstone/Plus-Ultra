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
    
    def sign_in 
      
      sign_in_test_user
      
      click_button "log_out_button"

      wait_for_text 'Signed out successfully'
    end 
    
    def sign_in_admin_user
      
      sign_in_admin
      
      admin_users_crud
    end
    
    
    def admin_users_crud
      header("Admin user CRUD")

      click '/admin/users'

      wait_for_text 'Manage Users'

      wait_for_text test_user[:email]

      set_text_field('filter_email', "zz")

      click_button "users_filter_button"
      
      wait_for_text "There are no users"

      set_text_field('filter_email', "")

      click_button "users_filter_button"
      
      wait_for_text test_user[:email]
      
      user = get_test_user
      
      click "/admin/users/#{user.id}/edit"
      
      wait_for_text "Edit User"

      scroll_to_bottom

      set_text_field('user_first_name', changed)

      set_select('user_time_zone', test_time_zone)

      click_button "admin_users_update_button"

      wait_for_text "successfully updated"
      
      click "/admin/users"

      wait_for_text "Manage Users"
      
      wait_for_text changed.capitalize
      
      click "/admin/users/#{user.id}/edit"
      
      wait_for_text "Edit User"
      
      scroll_to_bottom

      wait_for_text test_time_zone
    end
  
end

ISUser.new