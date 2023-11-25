class UserMailer < ApplicationMailer
  
  layout false, only: [ 'campaign_communication' ]
  
  # TODO: move to communications
  def send_2fa_code(options)
    @user      = options[:user]
    @preheader = "#{ENV['APP_NAME']} verification code"
    mail(to: @user.email, subject: "Your verification code")  
  end
  
  def communication(options)
    Rails.logger.info "communication: 1"
    return if options[:communication].blank?
    return if options[:user].blank?
    
    Rails.logger.info "communication: 2"
    communication = options[:communication]
    campaign      = communication.campaign
    user          = options[:user]
    
    Rails.logger.info "communication: 3"
    # TODO: create campaign_sent record
    
    case 
    when communication.email? 
      Rails.logger.info "communication: 4"

      # transpose content
      subject = communication.transpose_subject(options).html_safe
      Rails.logger.info "communication: 5"
      preview = communication.transpose_preview(options).html_safe
      Rails.logger.info "communication: 6"
      content = communication.transpose_content(options).html_safe
      Rails.logger.info "communication: 7"
      
      # header and footer 
      header = ""
      footer = ""
      
      case 
      when communication.marketing?  
        Rails.logger.info "communication: 8"
        header = render_to_string(partial: 'shared/mailer/header_marketing', locals: { preheader: preview })
        footer = render_to_string(partial: 'shared/mailer/footer_marketing', locals: {})
      when communication.operations?  
        Rails.logger.info "communication: 9"
        header = render_to_string(partial: 'shared/mailer/header_operations', locals: { preheader: preview })
        footer = render_to_string(partial: 'shared/mailer/footer_operations', locals: {})
      end
      
      Rails.logger.info "communication: 10"
      
      # build the message
      @html = header + content + footer

      Rails.logger.info "communication: 11"

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
