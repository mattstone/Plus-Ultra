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
      ml = MailingList.find_by(name: "Changed") if ml.nil?
      ml
    end
    
    def test_subscriber_record 
      Subscriber.find_by(email: test_subscriber[:email])
    end

    def remove_test_data!
      MailingList.where(name: test_data[:name]).destroy_all
      MailingList.where(name: "Changed").destroy_all
      
      Subscriber.where(email: newsletter_subscriber[:email]).destroy_all
    end
    
    def create_mailing_list 
      header("Create Mailing List")

      link = @browser.link(href: '/admin/mailing_lists')
      link.click
      
      wait_for_text 'Manage Mailing Lists'
      
      link = @browser.link(href: '/admin/mailing_lists/new')
      link.click

      wait_for_text 'New mailing list'
      
      text_field = @browser.text_field(id: 'mailing_list_name')
      text_field.value = test_data[:name]
      
      @browser.button(:id => "mailing_list_save_button").click
      
      wait_for_text 'Mailing list was successfully created'
    end 
    
    def edit_mailing_list 
      header("Edit Mailing List")
      
      ml   = test_mailing_list
      link = @browser.link(href: "/admin/mailing_lists/#{ml.id}/edit")
      link.click

      text_field = @browser.text_field(id: 'mailing_list_name')
      text_field.value = "Changed"

      @browser.button(:id => "mailing_list_save_button").click
      
      wait_for_text 'Mailing list was successfully updated'

      wait_for_text "Changed"
    end 
    
    def search_mailing_list 
      header("Search Mailing List")
      
      text_field = @browser.text_field(id: 'filter_name')
      text_field.value = "zz"
      
      @browser.button(:id => "mailing_lists_filter_button").click
      wait_for_text "There are no Mailing Lists"

      text_field = @browser.text_field(id: 'filter_name')
      text_field.value = ""

      @browser.button(:id => "mailing_lists_filter_button").click
      wait_for_text "Changed"
    end 
    
    def add_subscriber
      header("Add Subscriber")
      
      ml   = test_mailing_list
      
      link = @browser.link(href: "/admin/mailing_lists/#{ml.id}/subscribers")
      link.click
      
      wait_for_text "Manage Subscribers for Changed"

      link = @browser.link(href: "/admin/mailing_lists/#{ml.id}/subscribers/new")
      link.click

      wait_for_text "New Subscriber"

      @browser.button(:id => "mailing_list_subscriber_save_button").click
      
      wait_for_text "1 error prohibited"
      
      sleep 1
      
      text_field = @browser.text_field(id: 'subscriber_email')
      text_field.value = test_subscriber[:email]
      
      scroll_to_bottom

      @browser.button(id: "mailing_list_subscriber_save_button").click

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
      
      @browser.button(:id => "admin_mailing_list_subscriber_delete_subscriber_#{subscriber.id}").click
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
      
      link = @browser.link(href: '/admin/mailing_lists')
      link.click

      wait_for_text 'Manage Mailing Lists'
      
      ml = test_mailing_list

      @browser.button(:id => "admin_mailing_list_delete_mailing_list_#{ml.id}").click
      sleep 1 
      
      case @browser.alert.exists?
      when true  then good("delete prompt")
      when false then bad("no delete prompt")
      end
      
      alert_ok
      
      wait_for_text "Mailing list was successfully destroyed"

      text_field = @browser.text_field(id: 'filter_name')
      text_field.value = "Changed"
      
      @browser.button(:id => "mailing_lists_filter_button").click

      wait_for_text "There are no Mailing Lists"

      text_field = @browser.text_field(id: 'filter_name')
      text_field.value = ""
      
      @browser.button(:id => "mailing_lists_filter_button").click
    end
    
    def newsletter_signup
      header("newsletter_signup")
      
      subscriber = newsletter_subscriber

      @browser.button(:id => "admin_sign_out").click
      sleep 1 
      
      wait_for_text "You have been successfully signed out"

      # Valid signup
      text_field = @browser.text_field(id: 'newsletter_email')
      text_field.value = subscriber[:email]

      sleep 3 # Stop capatch from killing request
      
      @browser.button(:id => "newsletter_email_button").click
      wait_for_text "Thanks for your interest!"

      # Already signed up
      go_home
      sleep 2
      
      # Valid signup
      text_field = @browser.text_field(id: 'newsletter_email')
      text_field.value = subscriber[:email]

      sleep 2 # Stop capatch from killing request

      @browser.button(:id => "newsletter_email_button").click
      wait_for_text "Email already subscribed"
    end
    
end

ISMailingList.new