class BulkEmail < ApplicationRecord
  
  validates :mailing_list_id,  presence: true
  validates :communication_id, presence: true

  belongs_to :mailing_list
  belongs_to :communication
  
  broadcasts_refreshes  
  
  def self.communications_for_select 
    Communication 
      .joins(:campaign) 
      .where({ campaign: { communication_type: "bulk_email" }})
      .all
  end

  def send!(current_user = nil)
    # Could be long running tasks, so run on background thread
    BulkEmailSenderJob.perform_later(self.id, current_user.id)
  end
  
  def send_from_background_job!(user_id = nil)
    @user   = User.find(user_id) if !user_id.nil?
    
    options = { communication: self.communication }

    # TODO: Batch email sending.. 
    self.mailing_list.subscribers
      .find_in_batches(batch_size: 20).each do |subscribers|
        subscribers.each do |sub|
          options[:to]         = sub.email
          options[:subscriber] = sub
          UserMailer::communication(options).deliver_now!
          self.sent += 1
        end
    end
    
    self.datetime_sent = Time.now 
    self.save
    
    # Let user know message has been sent
    if @user
      options = {
        user: @user,
        message: "Bulk email: #{communication.name} has been sent to #{self.sent} subscribers"
      }
      
      Rails.logger.info "send_from_background_job: #{options.inspect}".red
      
      UserMailer::admin(options).deliver_now!
    end
  end
  
end
