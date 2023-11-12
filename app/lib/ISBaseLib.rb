class ISBaseLib 
  
  def initialize 
  end 
  
  def l(string)
    case Rails.env.test?
    when true  then Rails.logger.debug string
    when false then Rails.logger.info string
    end
  end
  
end