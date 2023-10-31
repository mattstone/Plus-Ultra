

require File.join(__dir__, "./ISBaseWatir.rb")

class ISTemplate < ISBaseWatir
  
  def initialize 
    super
    
    remove_test_data!
  end
  
  def remove_test_data!
    # Custom logic
  end
  
  def test_thing 
    {
      variable: "value"
    }
  end
  
end

ISTemplate.new
