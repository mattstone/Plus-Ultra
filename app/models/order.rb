class Order < ApplicationRecord
  has_many :product_orders
  has_many :products, through: :product_orders
  has_many :transactions
  
  belongs_to :user
  
  validates :amount_in_cents, presence:   true

  
  def self.create_from_shopping_cart(current_user, shopping_cart)

    order = current_user.orders.new
    
    order.amount_in_cents = 0
    shopping_cart.each do |key, value|
      product = Product.find(key)
      order.amount_in_cents   += product.price_in_cents * value["count"]
      shopping_cart[key]["amount_in_cents"] = order.amount_in_cents
      shopping_cart[key]["price_in_cents"]  = product.price_in_cents
    end
    
    ActiveRecord::Base.transaction do
      order.save
      
      shopping_cart.each do |key, value| # create product_orders
        po = order.product_orders.new
        po.product_id      = key 
        po.quantity        = value["count"]
        po.price_in_cents  = value["price_in_cents"]
        po.amount_in_cents = value["amount_in_cents"]
        po.save
      end
    end
    
    current_user.stripe_customer_charge_once!({ order: order }) # Create transaction
    order
  end
  
  def status 
    transaction = self.transactions.first 
    return "Not placed" if transaction == nil
    transaction.status.to_s.humanize
  end
  
end
