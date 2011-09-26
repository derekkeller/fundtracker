class Organization < ActiveRecord::Base
  validates_presence_of :name
  
  has_many :funds
  has_many :companies, :through => :funds

end
