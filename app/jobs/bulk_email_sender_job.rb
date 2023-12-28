class BulkEmailSenderJob < ApplicationJob
  queue_as :default

  def perform(bulk_email_id, user_id)
    bulk_email = BulkEmail.find(bulk_email_id)
    return if bulk_email.nil?
    
    bulk_email.send_from_sidekiq!(user_id)
  end
end
