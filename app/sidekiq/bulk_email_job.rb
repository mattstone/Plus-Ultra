class BulkEmailJob
  include Sidekiq::Job

  def perform(bulk_email_id, user_id)
    # TODO - Mailgun has facility to bulk send (ie: in groups of 500) 
    #        This was causing problems. Will review as it's much more sensible
    
    bulk_email = BulkEmail.find(bulk_email_id)
    return if bulk_email.nil?
    
    bulk_email.send_from_sidekiq!(user_id)
  end
end
