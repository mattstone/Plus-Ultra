class CustomCommunicationValidator < ActiveModel::Validator
  def validate(record)
    
    case record.communication_type 
    when "email"
      record.errors.add(:subject, "required") if record.subject.blank?
      record.errors.add(:preview, "required") if record.preview.blank?
    end

    record.errors.add(:content, "required") if record.content.blank?
        
  end
end

class Communication < ApplicationRecord
  has_rich_text :preview 
  has_rich_text :content 
  
  belongs_to :campaign
  has_many   :bulk_emails

  enum :communication_type, { email: 0, sms: 1, outbound_telephone: 2, inbound_telephone: 3 }, prefix: true
  enum :layout,             { operations: 0, marketing: 1 }, prefix: true
  enum :lifecycle,          { customer_aquisition: 0, pre_sales: 1, post_sales: 2, end_of_relationship: 3, newsletter: 4, blog: 5 }, prefix: true
  
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :campaign_id, presence: true
  
  validates_with CustomCommunicationValidator

  def email?
    self.communication_type_email?
  end
  
  def sms?
    self.communication_type_sms?
  end

  def outbound_telephone?
    self.communication_outbound_telephone?
  end

  def inbound_telephone?
    self.communication_inbound_telephone?
  end
  
  def operations?
    self.layout_operations?
  end 
  
  def marketing?
    self.layout_marketing?
  end
  
  def transpose_subject(options)
    options[:transpose] = "subject"
    transpose(options)
  end
  
  def transpose_preview(options)
    options[:transpose] = "preview"
    transpose(options)
  end
  
  def transpose_content(options)
    options[:transpose] = "content"
    transpose(options)
  end
  
  def transpose(options)
    string = case options[:transpose]
      when "subject" then self.subject.to_s.dup
      when "preview" then self.preview.to_s.dup
      when "content" then self.content.to_s.dup
      end
        
    if options[:user]
      user = options[:user]
      
      string.gsub!("%FIRST_NAME%", user.first_name.to_s.humanize)
      string.gsub!("%FULL_NAME%",  user.full_name)
      string.gsub!("%2FA_CODE%",   user.one_time_code.to_s)
    end
    
    string
  end

end