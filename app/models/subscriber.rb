class CustomSubscriberValidator < ActiveModel::Validator
  def validate(record)
    
    if !record.mobile_number.blank? 
      if record.mobile_number_country_code.blank?
        record.errors.add(:mobile_number_country_code, "invalid for mobile number")
      end

      if !Phonelib.valid_for_country? record.mobile_number, record.mobile_number_country_code
        record.errors.add(:mobile_number,    "invalid for country code")
      end      
    end
    
  end
end

class Subscriber < ApplicationRecord
  belongs_to :mailing_list
  
  validates_with CustomSubscriberValidator
  validates :email, format: { with: Devise.email_regexp }
  
  def international_mobile
    return "" if mobile_number.blank?
    Phony.normalize("#{self.mobile_number_country_code}#{self.mobile_number}")
  end
  
  def full_name 
    "#{first_name} #{last_name}"
  end
  
end


