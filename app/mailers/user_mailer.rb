class UserMailer < ApplicationMailer
  
  layout false, only: [ 'communication' ]
  
  # TODO: move to communications
  def send_2fa_code(options)
    @user      = options[:user]
    @preheader = "#{ENV['APP_NAME']} verification code"
    mail(to: @user.email, subject: "Your verification code")  
  end
  
  def communication(options)
    return if options[:communication].blank?
    return if options[:user].blank?
    
    communication = options[:communication]
    campaign      = communication.campaign
    user          = options[:user]
    
    # TODO: create campaign_sent record
    
    if options[:test] == true 
      # setup for test
    end
    
    case 
    when communication.email? 

      # transpose content
      subject = communication.transpose_subject(options).html_safe
      preview = communication.transpose_preview(options).html_safe
      content = communication.transpose_content(options).html_safe
      
      # header and footer 
      header = ""
      footer = ""
      
      case 
      when communication.marketing?  
        header = render_to_string(partial: 'shared/mailer/header_marketing', locals: { preheader: preview })
        footer = render_to_string(partial: 'shared/mailer/footer_marketing', locals: {})
      when communication.operations?  
        header = render_to_string(partial: 'shared/mailer/header_operations', locals: { preheader: preview })
        footer = render_to_string(partial: 'shared/mailer/footer_operations', locals: {})
      end
      
      # build the message
      @html = header + content + footer
      
      case
      when options[:preview] == true
        ISRedis.set_ex("communication_#{communication.id}", { html: @html }, 60) # Save to redis and expire in 60 seconds
        return
      when options[:preview_new] == true
        ISRedis.set_ex("communication_#{user.id}", { html: @html }, 60) # Save to redis and expire in 60 seconds
        return
      end

      # Handle attachments
      
      #
      # attachment should = { name: "name recipient sees", file: "path to file" }
      #
      if options[:attachments]
        email_attachments = options[:attachments].instance_of?(Array) ? options[:attachments] : options[:attachments]
        
        email_attachments.each do |attachment|
          attachments[attachment[:name]] = File.read(attachment[:file])
        end
      end


      # TODO: Bulk email sender for marketing campaigns
      mail(to: user.email, from: ENV['FROM_EMAIL'], bcc: options[:bcc], subject: subject)
      
    when communication.sms
      ISTwilio.sms_send!({ to: user.mobile, message: communication.transpose_content(options).html_safe })
    end
    
  end
  
end
