class Product < ApplicationRecord
  has_rich_text :teaser 
  has_rich_text :description 
  
  has_one_attached :main_image, dependent: :destroy do |attachable|
    attachable.variant :thumb,   resize_to_limit: [100, 100]
    attachable.variant :preview, resize_to_limit: [300, 300]
    attachable.variant :medium,  resize_to_limit: [600, 600]
  end
  

  # add validations 
  validates :name, :price, :sku, presence: true
  validates :name, :sku, uniqueness: true  
  
  # add enums
  enum :purchase_type, { purchase: 0, subscription: 100}, prefix: true
  enum :billing_type,  { once_off: 0, weekly: 100, fortnightly: 200, monthly: 300, annually: 400 }, prefix: true

end
