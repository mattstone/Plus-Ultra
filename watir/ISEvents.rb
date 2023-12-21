require File.join(__dir__, "./ISBaseWatir.rb")

class ISEvents < ISBaseWatir
  
  def initialize 
    super
    
    remove_test_data!
    create_and_confirm_admin_user!
    
    sign_in_admin
  end
  
  def remove_test_data!
    Event.destroy_all
  end
  
end


ISEvents.new