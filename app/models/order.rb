class Order < ApplicationRecord
  audited
  
  has_many :product_orders
  has_many :products, through: :product_orders
  has_many :transactions
  has_many :subscriptions
  
  belongs_to :user
  
  validates :amount_in_cents, presence:   true

  
  # Note: subscriptions.. must use different process.
  def self.create_from_shopping_cart(current_user, shopping_cart)

    ActiveRecord::Base.transaction(isolation: :serializable) do
      order = current_user.orders.new
      
      order.amount_in_cents = 0
      shopping_cart.each do |key, value|
        product = Product.find(key)
        order.amount_in_cents   += product.price_in_cents * value["count"]
        shopping_cart[key]["amount_in_cents"] = order.amount_in_cents
        shopping_cart[key]["price_in_cents"]  = product.price_in_cents
      end
    
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
    
    current_user.stripe_create_payment_intent!({ order: order }) # Create transaction
    order
  end
  
  def self.create_for_subscription!(current_user, options)
    order = nil
    ActiveRecord::Base.transaction(isolation: :serializable) do
      
      order = current_user.orders.new
      order.amount_in_cents = options[:product].price_in_cents 
      order.save 
      
      po = order.product_orders.new 
      po.product_id = options[:product].id

      current_user.stripe_create_payment_intent!({ order: order }) # Create transaction
    end
    order
  end
  
  def status 
    transaction = self.transactions.first 
    return "Not placed" if transaction == nil
    transaction.status.to_s.humanize
  end
  
  def order_number
    "or-#{self.id}"
  end
  
  def subscription?
    # Note: will only be one product for a subscription
    self.products&.first.purchase_type_subscription?
  end
  
end
