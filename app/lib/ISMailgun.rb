class ISMailgun 
  
  def initialize 
  end 
  
  def send_mail!(options)
    client = Mailgun::Client.new(ENV["MAILGUN_API_KEY"])
    client.send_message ENV['DOMAIN'], options
  end
  
end