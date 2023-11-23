class Channel < ApplicationRecord
  has_many :campaigns, dependent: :destroy
  
  validates :name, presence: true
  validates :name, uniqueness: true

end
