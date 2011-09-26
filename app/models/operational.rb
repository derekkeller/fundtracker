class Operational < ActiveRecord::Base
  attr_accessible :period_end, :head_count, :debt_balance, :cash_balance, :cash_burn
  
  belongs_to :company
  
  def validate
    if Operational.where(['month(period_end) = ? AND year(period_end) = ?', self.period_end.month, self.period_end.year]).present?
      self.errors.add_to_base("duplicate operational data for this period detected")
    end
  end
  
  def to_s
    self.period_end.strftime("%m/%Y") unless self.period_end.nil?
  end
end
