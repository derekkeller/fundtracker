class Forecast < ActiveRecord::Base
  # attr_accessible :bookings, :revenue, :cogs, :operating_expenses, :sg_and_a, :r_and_d, :depreciation, :amortization, :interest_income, :interest_expense, :other_income, :other_expense, :tax_expense, :period, :custom_cells_attributes
  
  validates_presence_of :period, :company_id
  
  belongs_to :company

  has_many :custom_cells
  
  accepts_nested_attributes_for :custom_cells
  
  validates :period, :unique_record => true
  
  def to_s
    self.period.strftime("%m/%Y") unless self.period.nil?
  end
  
end
