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
    end
    
    order.save
    
    # create product_orders
    shopping_cart.each do |key, value|
      product_order = ProductOrder.new 
      product_order.orders_id   = order.id 
      product_order.products_id = key 
      product_order.amount_in_cents = value["amount_in_cents"]
      product_order.save
    end
    
    # Create transaction
    current_user.stripe_customer_charge_once!({ order: order })
    order
  end
  
  def status 
    transaction = self.transactions.first 
    return "Unprocessable" if transaction.nil 
    transaction.status.to_s.humanize
  end
  
end
