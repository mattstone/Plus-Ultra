class Campaign < ApplicationRecord
  belongs_to :channel
  
  has_many :users 
  has_many :transactions
  has_many :communications
  
  validates :name, presence: true
  validates :name, uniqueness: true
  
  after_save :set_tag_and_name
  
  enum :communication_type, { none: 0, email: 1, sms: 2, outbound_telephone: 3, inbound_telephone: 4 }, prefix: true
  
  def link 
    "#{ENV['WHO_AM_I']}?tag=#{self.tag}"
  end
  
  private 
  
  def set_tag_and_name 
    return if !self.tag.nil?
    
    temp_name = "#{Time.now.strftime("%Y%m%d")} #{self.name}"
    self.update_column :name, temp_name
    
    self.update_column :tag, "#{self.id}"
  end 
  
end
