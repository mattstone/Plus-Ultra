

require File.join(__dir__, "./ISBaseWatir.rb")

class ISTemplate < ISBaseWatir
  
  def initialize 
    super
    
    remove_test_data!
    
    test_runner
    tests_complete
  end
  
  def remove_test_data!
    # Custom logic
  end
  
  def test_thing 
    {
      variable: "value"
    }
  end
  
  def test_runner
    super
  end
  
end

ISTemplate.new
