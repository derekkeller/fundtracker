class CustomCell < ActiveRecord::Base
  attr_accessible :amount, :user_defined_category_id, :period_result_id, :sign
  
  belongs_to :period_result
  belongs_to :forecast
  belongs_to :user_defined_category
  
  def to_s
    self.amount
  end
end
