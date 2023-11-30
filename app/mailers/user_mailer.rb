class UserMailer < ApplicationMailer
  
  layout false, only: [ 'communication' ]
  
  # TODO: move to communications
  def send_2fa_code(options)
    @user      = options[:user]
    @preheader = "#{ENV['APP_NAME']} verification code"
    mail(to: @user.email, subject: "Your verification code")  
  end
  
  def admin(options)
    @user   = options[:user]
    @messge = options[:message]
    mail(to: @user.email, subject: options[:subject])  
  end
  
  def communication(options)
    return if options[:communication].blank?
    # return if options[:user].blank?
    
    communication = options[:communication]
    campaign      = communication.campaign
    # user          = options[:user]
    subscriber    = options[:subscriber]
    
    if options[:user]
      @user    = options[:user]
      to_email = user.email 
    else 
      to_email = options[:to]
    end
    
    case options[:test] == true 
    when true  # setup for test
    when false # setup for tracking
      communication.create_communication_sent!(options) # Setup tracking
    end
    
    #<CampaignSent:0x0000000116ae4130 id: nil, campaign_id: nil, user_id: nil, subscriber_id: nil, opens: 0, clicks: 0, history: [], created_at: nil, updated_at: nil>
    
    case 
    when communication.email? 

      # transpose content
      subject = communication.transpose_subject(options).html_safe
      preview = communication.transpose_preview(options).html_safe
      content = communication.transpose_content(options).html_safe
      
      # header and footer 
      header = ""
      footer = ""
      
      header_options = {}
      header_options[:preheader]     = preview
      header_options[:campaign]      = campaign
      header_options[:communication] = communication
      header_options[:user]          = options[:user].blank?       ? nil : options[:user]
      header_options[:subscriber]    = options[:subscriber].blank? ? nil : options[:subscriber]
      
      case 
      when communication.marketing?  
        header = render_to_string(partial: 'shared/mailer/header_marketing', locals: header_options)
        footer = render_to_string(partial: 'shared/mailer/footer_marketing', locals: {})
      when communication.operations?  
        header = render_to_string(partial: 'shared/mailer/header_operations', locals: header_options)
        footer = render_to_string(partial: 'shared/mailer/footer_operations', locals: {})
      end
      
      # build the message
      @html = header + content + footer
      
      if options[:preview] or options[:preview_new]
        # write email content to redis for previewing - ie: do not send
        case
        when options[:preview] == true
          ISRedis.set_ex("communication_#{communication.id}", { html: @html }, 60) # Save to redis and expire in 60 seconds
          return
        when options[:preview_new] == true
          ISRedis.set_ex("communication_#{@user.id}", { html: @html }, 60) # Save to redis and expire in 60 seconds
          return
        end
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

      case communication.layout
      when "operations"
        mail(to: to_email, from: ENV['FROM_EMAIL'], bcc: options[:bcc], subject: subject)
      when "marketing"
        # Send through mailgun - we don't want to polute our operations IP address with marketing emails
        mailgun_options = {
          from:    ENV['FROM_EMAIL_MARKETING'],
          to:      to_email,
          subject: communication.subject,
          html:    @html
        }
        
        if Rails.env.production?
          mg = ISMailgun.new
          mg.send_mail!(mailgun_options)
        end
      end
      
    when communication.sms
      ISTwilio.sms_send!({ to: user.mobile, message: communication.transpose_content(options).html_safe })
    end
    
  end
  
end
