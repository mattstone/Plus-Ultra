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
    end
    
    def create_mailing_list 
      header("Create Mailing List")

      link = @browser.link(href: '/admin/mailing_lists')
      link.click
      
      @browser.wait_until { @browser.text.include? 'Manage Mailing Lists' }
      good("browsed to admin/mailing_lists")
      
      link = @browser.link(href: '/admin/mailing_lists/new')
      link.click

      @browser.wait_until { @browser.text.include? 'New mailing list' }
      good("browsed to admin/mailing_lists/new")
      
      text_field = @browser.text_field(id: 'mailing_list_name')
      text_field.value = test_data[:name]
      
      @browser.button(:id => "mailing_list_save_button").click
      
      @browser.wait_until { @browser.text.include? 'Mailing list was successfully created' }
      good("created Mailing List successfull")

    end 
    
    def edit_mailing_list 
      header("Edit Mailing List")
      
      ml   = test_mailing_list
      link = @browser.link(href: "/admin/mailing_lists/#{ml.id}/edit")
      link.click

      text_field = @browser.text_field(id: 'mailing_list_name')
      text_field.value = "Changed"

      @browser.button(:id => "mailing_list_save_button").click
      
      @browser.wait_until { @browser.text.include? 'Mailing list was successfully updated' }
      good("mailing list updated")

      @browser.wait_until { @browser.text.include? "Changed" }
      good("mailing list updated - confirmed")
      
    end 
    
    def search_mailing_list 
      header("Search Mailing List")
      
      text_field = @browser.text_field(id: 'filter_name')
      text_field.value = "zz"
      
      @browser.button(:id => "mailing_lists_filter_button").click
      @browser.wait_until { @browser.text.include? "There are no Mailing Lists" }
      good("mailing list filter ")


      text_field = @browser.text_field(id: 'filter_name')
      text_field.value = ""

      @browser.button(:id => "mailing_lists_filter_button").click
      @browser.wait_until { @browser.text.include? "Changed" }
      good("mailing list filter confirmed")

    end 
    
    def add_subscriber
      header("Add Subscriber")
      
      ml   = test_mailing_list
      
      link = @browser.link(href: "/admin/mailing_lists/#{ml.id}/subscribers")
      link.click
      
      @browser.wait_until { @browser.text.include? "Manage Subscribers for Changed" }
      good("browse to subscribers page")

      link = @browser.link(href: "/admin/mailing_lists/#{ml.id}/subscribers/new")
      link.click

      @browser.wait_until { @browser.text.include? "New Subscriber" }
      good("browse to subscribers page")

      @browser.button(:id => "mailing_list_subscriber_save_button").click
      
      @browser.wait_until { @browser.text.include? "1 error prohibited" }
      good("subscriber validations good")
      
      sleep 1
      
      text_field = @browser.text_field(id: 'subscriber_email')
      text_field.value = test_subscriber[:email]
      
      @browser.scroll.to :bottom

      sleep 1

      @browser.button(id: "mailing_list_subscriber_save_button").click

      @browser.wait_until { @browser.text.include? "Subscriber was successfully created" }
      good("created subscriber")
      
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

      @browser.alert.ok
      
      @browser.wait_until { @browser.text.include? "Subscriber was successfully destroyed" }
      good("subscriber deleted")
      
    end
    
    def delete_mailing_list
      header("Delete Mailing List")
      
      link = @browser.link(href: '/admin/mailing_lists')
      link.click

      @browser.wait_until { @browser.text.include? 'Manage Mailing Lists' }
      good("browsed to admin/mailing_lists")
      
      ml   = test_mailing_list

      @browser.button(:id => "admin_mailing_list_delete_mailing_list_#{ml.id}").click
      sleep 1 
      
      case @browser.alert.exists?
      when true  then good("delete prompt")
      when false then bad("no delete prompt")
      end
      
      @browser.alert.ok
      
      @browser.wait_until { @browser.text.include? "Mailing list was successfully destroyed" }
      good("mailing list deleted")

      text_field = @browser.text_field(id: 'filter_name')
      text_field.value = "Changed"
      
      @browser.button(:id => "mailing_lists_filter_button").click
      @browser.wait_until { @browser.text.include? "There are no Mailing Lists" }
      good("mailing list filter does not show deleted mailing list ")

      text_field = @browser.text_field(id: 'filter_name')
      text_field.value = ""
      
      @browser.button(:id => "mailing_lists_filter_button").click
      
      sleep 180
    end
    
end

ml = ISMailingList.new