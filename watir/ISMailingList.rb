require File.join(__dir__, "./ISBaseWatir.rb")

class ISMailingList < ISBaseWatir
  
    def initialize 
      super
    
      remove_test_data!
      create_and_confirm_admin_user!
      
      sign_in_admin
      
      create_mailing_list 
      edit_mailing_list 
      search_mailing_list
      
      add_subscriber
      delete_subscriber
       
      delete_mailing_list
      
      newsletter_signup
    end
    
    def test_data 
      {
        name: "test mailing list"
      }
    end
    
    def test_subscriber 
      {
        email: "hello@internetschinternet.com"
      }
    end
    
    def newsletter_subscriber 
      {
        email: "newsletter@internetschinternet.com"
      }
    end
    
    def test_mailing_list 
      ml = MailingList.find_by(name: test_data[:name])
      ml = MailingList.find_by(name: changed) if ml.nil?
      ml
    end
    
    def test_subscriber_record 
      Subscriber.find_by(email: test_subscriber[:email])
    end

    def remove_test_data!
      # MailingList.where(name: test_data[:name]).destroy_all
      # MailingList.where(name: "Changed").destroy_all
      MailingList.destroy_all
      Subscriber.destroy_all
      
      MailingList.create(name: "Newsletter")
    end
    
    def create_mailing_list 
      header("Create Mailing List")

      click '/admin/mailing_lists'

      wait_for_text 'Manage Mailing Lists'
      
      click '/admin/mailing_lists/new'

      wait_for_text 'New mailing list'
      
      set_text_field('mailing_list_name', test_data[:name])
      
      @browser.button(:id => "mailing_list_save_button").click
      
      wait_for_text 'Mailing list was successfully created'
    end 
    
    def edit_mailing_list 
      header("Edit Mailing List")
      
      ml   = test_mailing_list
      
      click "/admin/mailing_lists/#{ml.id}/edit"

      set_text_field('mailing_list_name', changed)

      @browser.button(:id => "mailing_list_save_button").click
      
      wait_for_text 'Mailing list was successfully updated'

      wait_for_text changed
    end 
    
    def search_mailing_list 
      header("Search Mailing List")
      
      set_text_field('filter_name', "zz")
      
      @browser.button(:id => "mailing_lists_filter_button").click
      wait_for_text "There are no Mailing Lists"

      set_text_field('filter_name', "")

      @browser.button(:id => "mailing_lists_filter_button").click
      
      wait_for_text changed
    end 
    
    def add_subscriber
      header("Add Subscriber")
      
      ml   = test_mailing_list
      
      click "/admin/mailing_lists/#{ml.id}/subscribers"
      
      wait_for_text "Manage Subscribers for"

      click "/admin/mailing_lists/#{ml.id}/subscribers/new"

      wait_for_text "New Subscriber"

      click_button "mailing_list_subscriber_save_button"
      
      wait_for_text "1 error prohibited"
      
      sleep 1
      
      set_text_field('subscriber_email', test_subscriber[:email])
      
      scroll_to_bottom

      click_button "mailing_list_subscriber_save_button"

      wait_for_text "Subscriber was successfully created"
      
      # test country code and mobile numbers
      sub = test_subscriber_record
      sub.mobile_number_country_code = "AU"
      sub.mobile_number               = "0491570006"
      
      case sub.international_mobile == "61491570006"
      when true  then good("international mobile")
      when false then bad("international mobile")
      end
      
    end
    
    def delete_subscriber 
      header("Delete Subscriber")
      
      ml         = test_mailing_list
      subscriber = test_subscriber_record
      
      click_button "admin_mailing_list_subscriber_delete_subscriber_#{subscriber.id}"
      
      sleep 1 
      
      case @browser.alert.exists?
      when true  then good("delete prompt")
      when false then bad("no delete prompt")
      end

      alert_ok
      
      wait_for_text "Subscriber was successfully destroyed"
    end
    
    def delete_mailing_list
      header("Delete Mailing List")
      
      click '/admin/mailing_lists'

      wait_for_text 'Manage Mailing Lists'
      
      ml = test_mailing_list

      click_button "admin_mailing_list_delete_mailing_list_#{ml.id}"
      sleep 1 
      
      case @browser.alert.exists?
      when true  then good("delete prompt")
      when false then bad("no delete prompt")
      end
      
      alert_ok
      
      wait_for_text "Mailing list was successfully destroyed"

      set_text_field('filter_name', changed)
      
      click_button "mailing_lists_filter_button"

      wait_for_text "There are no Mailing Lists"

      set_text_field('filter_name', "")
      
      click_button "mailing_lists_filter_button"
    end
    
    def newsletter_signup
      header("newsletter_signup")
      
      subscriber = newsletter_subscriber

      click_button "admin_sign_out"
      
      sleep 1 
      
      wait_for_text "You have been successfully signed out"

      # Valid signup
      set_text_field('newsletter_email', subscriber[:email])

      sleep 3 # Stop capatch from killing request
      
      click_button "newsletter_email_button"
      
      wait_for_text "Thanks for your interest!"

      # Already signed up
      go_home
      sleep 2
      
      # Valid signup
      set_text_field('newsletter_email', subscriber[:email])

      sleep 2 # Stop capatch from killing request

      click_button "newsletter_email_button"
      
      wait_for_text "Email already subscribed"
    end
    
end

ISMailingList.new