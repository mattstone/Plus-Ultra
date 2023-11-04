class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable         
         
  enum :role, { customer: 0, admin: 100}, prefix: true
  
  has_many :transactions
  
  validates :first_name, :last_name, presence: true

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
  
  def admin!
    self.role_admin!
  end
end
