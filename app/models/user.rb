class User < ApplicationRecord
  audited
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable         
         
  enum :role, { customer: 0, admin: 100}, prefix: true
  
  has_many :transactions
  has_many :orders
  has_many :subscriptions
  has_many :blogs
  has_many :events
  
  belongs_to :campaigns, optional: true
  
  belongs_to :terms_and_conditions, optional: true
  
  broadcasts_refreshes
  
  validates :first_name, :last_name, presence: true
  
  after_create do 
    self.stripe_customer_create! if !self.role_admin?
  end

  def admin? 
    self.role_admin?
  end
  
  def full_name 
    "#{first_name.humanize} #{last_name.humanize}"
  end

  #
  # One time code
  #
  
  def send_new_one_time_code!         
    generate_one_time_code!
    send_one_time_code
  end
  
  def send_one_time_code 
    # UserMailer::send_2fa_code({ user: self }).deliver_now!
    options = {}
    options[:communication] = Communication::sign_up_2fa_email
    options[:user]          = self
    UserMailer::communication(options).deliver_now!
  end
 
  def generate_one_time_code!
    unique = false
    while !unique do
      self.one_time_code = rand(100000..999999)
      unique = true if User.find_by(one_time_code: self.one_time_code) == nil
    end
     
    self.save 
  end
  
  #
  # One time code End
  #
  
  #
  # Stripe start
  #
  
  def stripe_customer_create!
    return { error: "Already exists" } if !self.stripe_customer_id.nil?
    
    stripe   = ISStripe.new 
    response = stripe.customer_create({ email: self.email })
    
    begin 
      case response[:error].nil?
      when false then return(response[:error])
      when true 
        self.stripe_customer_id = response[:id]
        self.save
      end
    rescue => e 
      return e
    end
  end
    
  # current_user.stripe_create_payment_intent!({ product: product })
  
  def stripe_create_payment_intent!(options)
    order       = options[:order]
    stripe      = ISStripe.new
    transaction = nil
    self.stripe_customer_create! if self.stripe_customer_id.nil?

    ActiveRecord::Base.transaction(isolation: :serializable) do
      transaction = self.transactions.new
      transaction.order          = options[:order]
      transaction.price_in_cents = options[:order].amount_in_cents
      transaction.save!

      options[:order]              = order
      options[:transaction]        = transaction
      options[:stripe_customer_id] = self.stripe_customer_id
      options[:receipt_email]      = self.email
      
      payment_intent = stripe.payment_intent_create(options)
      
      transaction.history << payment_intent
      transaction.stripe_client_secret  = payment_intent["client_secret"] if payment_intent["client_secret"]
      transaction.stripe_payment_intent = payment_intent["id"]            if payment_intent["id"]
      transaction.save
    end
    transaction
  end
  
  def stripe_create_subscription!(options)
    stripe      = ISStripe.new
    transaction = options[:transaction]
    order       = transaction.order
    product     = order.products.first
    
    # Make payment method default for customer 
    options = {}      
    options[:invoice_settings] = { default_payment_method: transaction.stripe_payment_method }
    stripe.customer_update(self.stripe_customer_id, options)
    
    sleep 1 # Need a sec..

    # Create subscription 
    subscription = order.subscriptions.new
    subscription.user    = order.user
    subscription.product = product 
    subscription.status  = "incomplete"
    subscription.save
    
    items   = []
    items << { price: product.stripe_price_id }
    
    stripe_options            = {}
    stripe_options[:customer] = self.stripe_customer_id
    stripe_options[:items]    = items
    stripe_options[:metadata] = { subscription_id: subscription.id }
    idempotency_key        = "sub_#{self.id}_#{transaction.id}"
    stripe.subscription_create(stripe_options, idempotency_key) # Webhook will handle result
  end
  
  #
  # Stripe End 
  #
  
  def admin!
    self.role_admin!
  end
  
  if Rails.env.development?
    def self.email_test 
      u    = User.last
      comm = Communication.find(4)
      
      UserMailer.communication({ user: u, communication: comm }).deliver_now!
    end
  end
  
  
end
