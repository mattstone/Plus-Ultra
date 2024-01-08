require File.join(__dir__, "./ISBaseWatir.rb")

class ISTermsAndConditions < ISBaseWatir
  
  def initialize 
    super
    
    remove_test_data!
    create_and_confirm_admin_user!
    
    sign_in_admin
    
    test_runner
    
    tests_complete
  end
  
  def remove_test_data!
    # Custom logic
    TermsAndCondition.destroy_all
  end
  
  def test_runner 
    super
    
    create_terms_and_conditions
    update_terms_and_conditions
    create_should_duplicate_last_published
  end
  
  def create_terms_and_conditions
    header("create_terms_and_conditions")
        
    click '/admin/terms_and_conditions'
    
    wait_for_text 'Manage Terms and Conditions'
    
    click '/admin/terms_and_conditions/new'
    
    wait_for_text 'New Terms and Conditions'
    
    set_select('terms_and_condition_status', test_terms_and_conditions[:status])
    
    execute_javascript("document.getElementById('terms_and_condition_content_trix_input_terms_and_condition').value = '<div>#{test_terms_and_conditions[:content]}</div>'")

    click_button 'admin_terms_and_conditions_update_button'
    
    sleep 1 
    
    wait_for_text 'Draft'
    
  end
  
  def update_terms_and_conditions
    header("update_terms_and_conditions")
    
    tc = test_terms_and_conditions_db
    
    click "/admin/terms_and_conditions/#{tc.id}/edit"
    
    wait_for_text 'Edit Terms and Conditions'

    wait_for_text 'Draft'

    set_select('terms_and_condition_status', 'published')

    click_button 'admin_terms_and_conditions_update_button'
    
    sleep 1 
    
    wait_for_text 'Published'

  end
  
  def create_should_duplicate_last_published 
    header("create_should_duplicate_last_published")

    wait_for_text 'Manage Terms and Conditions'
    
    click '/admin/terms_and_conditions/new'
    
    wait_for_text test_terms_and_conditions[:content]

  end
  
end

ISTermsAndConditions.new
