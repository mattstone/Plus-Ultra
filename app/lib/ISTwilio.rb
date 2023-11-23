class ISTwilio 
  
  def initialize 
  end 
  
  
  #
  # Useage:
  #
  # ISTwilio.sms_send!({ to: "+614...", message: "your message text here" })
  #
  
  def self.sms_send!(options)
    
    twilio = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    
    begin 
      result = twilio.messages.create(
        body:            options[:message],
        from:            ENV['TWILIO_MOBILE_NUMBER'],
        status_callback: ENV['TWILIO_CALLBACK_URL'],
        to:              options[:to]
      )
      
      # TODO: handle campaign_sent -> result.sid
      
    rescue => e 
    end

  end 
  
end