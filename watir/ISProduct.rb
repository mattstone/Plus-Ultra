require File.join(__dir__, "./ISBaseWatir.rb")

class ISProduct < ISBaseWatir
  
  def initialize 
    super
    
    remove_test_data!
  end
  
  
  def remove_test_data!
  end 
  
  def test_product 
    {
      name: "Test product",
      sku: "12345"
    }
  end 
  
end

ISProduct.new
