class UserDefinedCategory < ActiveRecord::Base
  attr_accessible :name, :c_type, :sign
  
  belongs_to :company
  
  validates_presence_of :name, :c_type
  validates_inclusion_of :sign, :in => [1, 2], :message => 'is required.'

  TYPES = { 1 => 'Revenue', 2 => 'COGS', 3 => 'Expense', 4 => 'Miscellaneous' }
  
  SIGNS = { 1 => 'Positive', 2 => 'Negative'}
  
  def to_s
    self.name
  end
  
  def category_type
    TYPES[self.c_type]
  end
  
end
