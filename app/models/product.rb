class Product < ApplicationRecord
  has_rich_text :teaser 
  has_rich_text :description 
  
  has_one_attached :main_image, dependent: :destroy do |attachable|
    attachable.variant :thumb,   resize_to_limit: [100, 100]
    attachable.variant :preview, resize_to_limit: [300, 300]
    attachable.variant :medium,  resize_to_limit: [600, 600]
  end
  
  has_many :transactions
  has_many :product_orders
  has_many :orders, through: :product_orders

  # add validations 
  validates :name, :price_in_cents, :sku, presence: true
  validates :name, :sku, uniqueness: true  
  
  # add enums
  enum :purchase_type, { purchase: 0, subscription: 100}, prefix: true
  enum :billing_type,  { once_off: 0, weekly: 100, fortnightly: 200, monthly: 300, annually: 400 }, prefix: true

  def subscription? 
    self.purchase_type_subscription?
  end

  def for_sale_to_s 
    for_sale ? "Yes" : "No"
  end
  
  def pricing_string 
    case self.purchase_type 
    when "purchase"     then ""
    when "subscription" 
      case self.billing_type 
      when "once_off"    then ""
      when "weekly"      then "per week"
      when "fortnightly" then "per fortnight"
      when "monthly"     then "per month"
      when "annually"    then "per year"
      end
    end
  end
  
  #
  # Start fulfillment  
  #
  
  def purchased!
    # Do what is needed to deliver product to customer
  end
  
  def refunded! 
    # Do what is needed to stop product delivery
  end
  
  #
  # End fulfillment
  #
  
end
