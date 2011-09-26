class YearSummary
  require 'period_summary'
  include PeriodSummary
  
  attr_accessor :year, :bookings, :revenue, :cogs, :operating_expenses, :sga, :r_and_d, :depreciation, :amortization, :interest_income, :other_income, :other_expense, :tax_expense, :total_revenue, :revenue_line_items, :cogs_line_items, :expense_line_items, :misc_line_items, :gross_profit, :gross_margin, :total_expense, :total_operating_expenses, :total_cogs, :operating_profit, :operating_margin, :net_income, :net_margin, :total_miscellaneous
  
  def initialize(company, year)
    @year = year
    @period = [Date.civil(year, 01, 01), Date.civil(year, 12, 31)]
    @company = company
    record = self.get_summary_data(@company, @period)[0]
    custom = self.get_custom_fields(@company, @period)

    begin
      @bookings                 = record['bookings']
      @revenue                  = record['revenue']
      @cogs                     = record['cogs']
      @operating_expenses       = record['operating_expenses'] || 0.0
      @sga                      = record['sga'] || 0.0
      @r_and_d                  = record['r_and_d'] || 0.0
      @depreciation             = record['depreciation']
      @amortization             = record['amortization']
      @interest_income          = record['interest_income']
      @other_income             = record['other_income']
      @other_expense            = record['other_expense']
      @tax_expense              = record['tax_expense']
      @total_operating_expenses = @sga + @operating_expenses + @r_and_d
      @total_revenue            = total_sub_total(@revenue, custom[0])
      @total_cogs               = total_sub_total_exp(@cogs, custom[1])
      @total_expense            = total_sub_total_exp(@total_operating_expenses, custom[2])
      @total_miscellaneous      = total_sub_total(@interest_income + @other_income - @tax_expense, custom[3])
      @gross_margin             = ((@total_revenue - @total_cogs) / @total_revenue.to_f) * 100
      @gross_profit             = @total_revenue - @total_cogs
      @operating_profit         = @gross_profit - @total_expense.abs
      @operating_margin         = @operating_profit / @total_revenue
      @net_income               = @operating_profit + @total_miscellaneous.abs
      @net_margin               = (@net_income / @total_revenue.to_f) * 100
      @revenue_line_items       = custom[0]
      @cogs_line_items          = custom[1]
      @expense_line_items       = custom[2]
      @misc_line_items          = custom[3]
    rescue
      @bookings                 = 0
      @revenue                  = 0
      @cogs                     = 0
      @operating_expenses       = 0
      @sga                      = 0
      @r_and_d                  = 0
      @depreciation             = 0
      @amortization             = 0
      @interest_income          = 0
      @other_income             = 0
      @other_expense            = 0
      @tax_expense              = 0
      @total_operating_expenses = 0
      @total_revenue            = 0
      @total_cogs               = 0
      @total_expense            = 0
      @total_miscellaneous      = 0
      @gross_margin             = 0
      @gross_profit             = 0
      @operating_profit         = 0
      @operating_margin         = 0
      @net_income               = 0
      @net_margin               = 0
      @revenue_line_items       = 0
      @cogs_line_items          = 0
      @expense_line_items       = 0
      @misc_line_items          = 0
    end
  end
  
end
