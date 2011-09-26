class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password, :clear_company
  
  attr_accessible :first_name, :last_name, :email, :password, :active, :fund_id, :role_id, :company_id
  
  belongs_to :fund
  belongs_to :company
  
  validates_presence_of :email, :first_name, :last_name
  validates_presence_of :password, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :email
  validates_confirmation_of :password
  validates_length_of :password, :within => 8..20, :allow_blank => true
  validates_presence_of :fund_id, :if => Proc.new { |u| u.is_admin == false && [1,2].include?(u.role_id) }
  validates_presence_of :role_id, :if => Proc.new { |u| u.is_admin == false }
  validates_presence_of :company_id, :if => Proc.new { |u| u.role_id == 3 }
  
  scope :active, where(:active => true)
  
  ROLES = { 1 => 'Fund Administrator', 2 => 'Fund User', 3 => 'Company User' }
    
  def encrypt_password
    if password.present?
      self.password_hash = BCrypt::Password.create(password)
    end
  end
  
  def clear_company
    # if the user role is not company user then no need for a company id
    if self.role_id != 3
      self.company_id = nil
    end
  end
  
  def to_s
    [first_name, last_name].join(' ')
  end
  
  def self.find_active_user(id)
    raise if id.nil?
    self.where(:active => true, :id => id).first
  end
  
  def show_role
    if self.is_admin?
      '<span title="Application Administrator">AA</span>'
    else
      case self.role_id
        when 1 then '<span title="Fund Administrator">FA</span>'
        when 2 then '<span title="Fund User">FU</span>'
        when 3 then '<span title="Company User">CU</span>'
      end
    end
  end
  
  def clear_recovery_params
    self.password_recovery_hash = nil
    self.recovery_hash_created_at = nil
    self.save
  end
  
  def _password
    BCrypt::Password.new(password_hash)
  rescue 
    ''
  end
  
  def company_array
    if self.fund_id.nil?
      self.company.to_a
    else
      self.fund.companies.all
    end
  end
  
private
  
  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user && user._password == password
      user.update_attribute(:last_login, Time.now)
      user
    else
      nil
    end
  end
end
