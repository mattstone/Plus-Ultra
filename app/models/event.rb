class CustomEventValidator < ActiveModel::Validator

  def validate(record)
    
    if record.start_datetime and record.end_datetime
      if record.end_datetime <= record.start_datetime
        record.errors.add(:end_datetime, "must be greater than Start Time")
      end
    end
    
  end
end


class Event < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true
  validates :name, uniqueness: true
  
  validates :start_datetime, presence: true
  validates :end_datetime,   presence: true
  
  validates_with CustomEventValidator
  
  geocoded_by :location
  
  after_validation :geocode
  
  enum :event_type, { reminder: 0, meeting: 1, appointment: 2 }, prefix: true
  
  broadcasts_refreshes
  
  after_initialize do |event|
    # TODO: check for next working day
    event.start_datetime = (DateTime.now + 1.day).change(min: 30).change(sec: 0)
    event.end_datetime   = event.start_datetime + 1.hour
  end  
  
  def self.invitee(email) 
    { email: email, accepted: false, date_accepted: nil, uuid: SecureRandom.uuid }
  end
  
  def reminder?
    self.type_reminder?
  end

  def meeting?
    self.type_meeting?
  end

  def appointment?
    self.type_appointment?
  end

  def accept_invitation!(uuid)
    self.invitees.each do |i|
      if i["uuid"] == uuid 
        i["accepted"]      = true 
        i["date_accepted"] = DateTime.now
        self.save 
        break
      end
    end
  end 

  def decline_invitation!(uuid)
    self.invitees.each do |i|
      if i["uuid"] == uuid 
        i["accepted"]      = false 
        i["date_accepted"] = nil
        self.save 
        break
      end
    end
  end

end
