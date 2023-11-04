class ISCommon 
  
  def self.unsplash(options = {})
    width  = options[:width]  || 800 
    height = options[:height] || 400
    
    "https://source.unsplash.com/random/#{width}x#{height}"
  end
  
end