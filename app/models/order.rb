class Order < ApplicationRecord
  has_many :product_orders
  has_many :products, through: :product_orders
  
end
