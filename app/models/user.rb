class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable         
         
  enum :role, { customer: 0, admin: 100}, prefix: true
  
  has_many :transactions
  has_many :orders
  
  validates :first_name, :last_name, presence: true
  
  after_create do 
    self.stripe_customer_create! if !self.role_admin?
  end

  def admin? 
    self.role_admin?
  end
  
  def full_name 
    "#{first_name} #{last_name}"
  end

  #
  # One time code
  #
  
  def send_new_one_time_code!         
    generate_one_time_code!
    send_one_time_code
  end
  
  def send_one_time_code 
    UserMailer::send_2fa_code({ user: self }).deliver_now!
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
  
  if Rails.env.development? 
    def self.test 
      
      Transaction.destroy_all 
      
      options = {}
      options[:product] = Product.find(7)
      
      u = User.first 
      u.stripe_customer_charge_once!(options)
    end
  end
  
  # current_user.stripe_customer_charge_once!({ product: product })
  
  def stripe_customer_charge_once!(options)
    # create transaction 
    # product = options[:product]
    order   = options[:order]
    stripe  = ISStripe.new
    t       = nil
    
    ActiveRecord::Base.transaction do
      t = self.transactions.new
      t.order          = options[:order]
      t.price_in_cents = options[:order].amount_in_cents
      t.save!

      options[:order]              = order
      options[:transaction]        = t
      options[:stripe_customer_id] = self.stripe_customer_id
      options[:receipt_email]      = self.email
      
      payment_intent = stripe.payment_intent(options)
      
      Rails.logger.info "payment_intent".yellow 
      Rails.logger.info payment_intent.inspect.to_s.yellow
      
      t.history << payment_intent
      t.stripe_client_secret  = payment_intent["client_secret"]
      t.stripe_payment_intent = payment_intent["id"]
      t.save
    end
    t
  end
  
  def stripe_customer_charge_subscription!(options)
  end
  
  #
  # Stripe End 
  #
  
  def admin!
    self.role_admin!
  end
end
