class Company < ActiveRecord::Base
  # attr_accessible :fund_id, :name, :founded, :industry_id, :description, :reserves, :syndicate, :status_id, :status_date, :exit_amount, :fund_return, :notes, :active
  
  validates_presence_of :fund_id, :name, :industry_id
  
  belongs_to :fund
  has_many :series, :order => 'date desc'
  has_many :operationals, :order => 'period_end desc'
  has_many :period_results
  has_many :users
  has_many :documents
  has_many :folders
  has_many :user_defined_categories
  has_many :forecasts, :order => 'period asc'
  
  before_save :clear_status_date
  
  scope :active, where(:active => true)
  
  STATUS = {1 => 'Active', 2 => 'Exited', 3 => 'Write-off'}

  def to_s
    name
  end
  
  def investment_total
    self.series.inject(0.0) { |sum, s|  sum += s.investment }
  end
  
  def most_recent_series
    self.series.first.name.gsub(/Series/,'')
  rescue
    ''
  end
  
  def current_head_count
    self.operationals.first.head_count
  rescue
    0
  end
  
  def self.options_for_select
    self.active.map { |c| [c.name, c.id] }
  end
  
  def ttm_revenue
    # revenue from the past 12 months -- financials
    e = Date.today.end_of_month
    s = e.months_ago(12).beginning_of_month
    ttm = self.period_results.sum(:revenue, :conditions => ['period between ? AND ?', s, e])
  end
  
  def cash_runway
    self.operationals.first.cash_balance / self.operationals.first.cash_burn
  rescue
    0
  end
  
  def ownership_percentage
    self.series.first.fully_diluted_ownership
  rescue
    0
  end
  
private

  def clear_status_date
    # clear status date if not active
    if self.status_id == 1
      self.status_date = nil
    end
  end
end
