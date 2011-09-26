class PeriodResult < ActiveRecord::Base
  # attr_accessible :bookings, :revenue, :cogs, :operating_expenses, :sg_and_a, :r_and_d, :depreciation, :amortization, :interest_income, :interest_expense, :other_income, :other_expense, :tax_expense, :period, :custom_cells_attributes
  
  validates_presence_of :period, :company_id
  
  belongs_to :company
  has_many :custom_cells
  
  accepts_nested_attributes_for :custom_cells
  
  validates :period, :unique_record => true
  
  def to_s
    self.period.strftime("%m/%Y") unless self.period.nil?
  end
  
  def gross_margin
    ((self.total_revenue - self.total_cogs) / self.total_revenue.to_f) * 100
  end
  
  def gross_profit
    self.total_revenue - self.total_cogs
  end
  
  def total_operating_expenses
    self.operating_expenses + self.sg_and_a + self.r_and_d + total_expense
  end
  
  def operating_profit
    gross_profit - total_operating_expenses
  end
  
  def operating_margin
    operating_profit / self.total_revenue
  end
  
  def net_income
    operating_profit - self.interest_income - self.other_income - self.tax_expense - total_miscellaneous
  end
  
  def net_margin
    (self.net_income / self.total_revenue.to_f) * 100
  end
  
  def total_revenue
    rev = self.revenue ||= 0.0 
    rev += sum_by_category_sign(1,1)  #self.custom_cells.where('user_defined_categories.c_type' => 1, 'user_defined_categories.sign' => 1).includes(:user_defined_category).inject(0.0) { |sum, a| sum + a.amount }
    rev -= sum_by_category_sign(1,2)  #self.custom_cells.where('user_defined_categories.c_type' => 1, 'user_defined_categories.sign' => 2).includes(:user_defined_category).inject(0.0) { |sum, a| sum + a.amount }
  end
  
  def total_cogs
    cogs = self.cogs ||= 0.0
    cogs += sum_by_category_sign(2,1) #self.custom_cells.where('user_defined_categories.c_type' => 2, 'user_defined_categories.sign' => 1).includes(:user_defined_category).inject(0.0) { |sum, a| sum + a.amount }
    cogs -= sum_by_category_sign(2,2) #self.custom_cells.where('user_defined_categories.c_type' => 2, 'user_defined_categories.sign' => 2).includes(:user_defined_category).inject(0.0) { |sum, a| sum + a.amount }
  end
  
  def total_expense
    exp = 0.0
    exp += sum_by_category_sign(3,1) #self.custom_cells.where('user_defined_categories.c_type' => 3, 'user_defined_categories.sign' => 1).includes(:user_defined_category).inject(0.0) { |sum, a| sum + a.amount }
    exp -= sum_by_category_sign(3,2) #self.custom_cells.where('user_defined_categories.c_type' => 3, 'user_defined_categories.sign' => 2).includes(:user_defined_category).inject(0.0) { |sum, a| sum + a.amount }
  end

  def total_miscellaneous
    misc = 0.0
    misc += sum_by_category_sign(4, 1) #self.custom_cells.where('user_defined_categories.c_type' => 4, 'user_defined_categories.sign' => 1).includes(:user_defined_category).inject(0.0) { |sum, a| sum + a.amount }
    misc -= sum_by_category_sign(4, 2) #self.custom_cells.where('user_defined_categories.c_type' => 4, 'user_defined_categories.sign' => 2).includes(:user_defined_category).inject(0.0) { |sum, a| sum + a.amount }
  end
  
private  
  def sum_by_category_sign(c_type, sign)
    self.custom_cells.where('user_defined_categories.c_type' => c_type, 'user_defined_categories.sign' => sign).includes(:user_defined_category).inject(0.0) { |sum, a| sum + a.amount }
  end
end