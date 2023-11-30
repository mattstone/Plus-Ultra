class Campaign < ApplicationRecord
  belongs_to :channel
  
  has_many :users 
  has_many :transactions
  has_many :communications
  has_many :communication_sents
  
  validates :name, presence: true
  validates :name, uniqueness: true
  
  after_save :set_tag_and_name
  
  enum :communication_type, { none: 0, email: 1, bulk_email: 2, sms: 3, outbound_telephone: 4, inbound_telephone: 5, redirect: 6 }, prefix: true
  
  def link 
    "#{ENV['WHO_AM_I']}?tag=#{self.tag}"
  end
  
  def redirect?
    self.communication_type_redirect?
  end
  
  def redirection_url
    return "" if self.redirect_url.blank?
    "#{Rails.application.routes.url_helpers.bitly_url(bitly: self.id, host: ENV['DOMAIN'])}"
  end
  
  def add_one_to_clicks!
    self.clicks += 1
    self.save
  end
  
  private 
  
  def set_tag_and_name 
    return if !self.tag.nil?
    
    temp_name = "#{Time.now.strftime("%Y%m%d")} #{self.name}"
    self.update_column :name, temp_name
    
    self.update_column :tag, "#{self.id}"
  end 
  
end
