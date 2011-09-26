class Fund < ActiveRecord::Base
  
  attr_accessible :name, :number, :aggregate, :size, :management_fee, :start_date, :active, :organization_id
  
  validates_presence_of :name

  belongs_to :organization

  has_many :companies, :order => 'name'
  has_many :users
  
  has_many :users
  has_many :company_users, :through => :companies, :source => :users
  
  has_many :series, :through => :companies, :source => :series
  
  scope :active, where(:active => true)
  
  def to_s
    name
  end
  
  def self.options_for_select
    self.active.map { |f| [f.name, f.id] }
  end
  
  def invested_to_date
    self.series.inject(0) { |sum, s| sum + s.investment }
  end
  
  def reserves
    self.companies.inject(0) { |sum, c| sum + c.reserves }
  end
  
  def investible_capital
    self.size - self.management_fee - self.invested_to_date - self.reserves
  end
  
end
