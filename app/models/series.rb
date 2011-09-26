class Series < ActiveRecord::Base
  belongs_to :company
  attr_accessible :name, :existing_capital_raised, :date, :pre_money, :capital_raised, :post_money, :security_type, :share_price, :liquidation_preference, :liquidation_preference_cap, :dividends, :dividends_period, :shares_purchased, :preferred_ownership, :fully_diluted_ownership, :investment
  
  validates_format_of :name, :with => /^(Series|Seed)\s?[A-Z]?(-[0-9])*/
  
  validates_presence_of :name, :date
  
  def to_s
    name
  end
end
