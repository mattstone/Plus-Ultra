class MailingList < ApplicationRecord

  validates :name, presence:   true
  validates :name, uniqueness: true

  has_many :subscribers, dependent: :destroy
  
  def self.newsletter 
    MailingList.find_by(name: "Newsletter")
  end 
  
  
end
