class OperationalSummary
  require 'period_summary'
  include PeriodSummary
  
  attr_accessor :company, :period_set
  
  PeriodSet = Struct.new(:gross_margin, :operating_margin, :cash_burn, :year, :label, :bookings, :revenue, :revenue_line_items, :cogs, :cogs_line_items, :gross_profit, :operating_expense, :sga, :r_and_d, :total_operating_expenses, :expense_line_items, :operating_profit, :interest_income, :other_income, :tax_expense, :misc_line_items, :total_miscellaneous, :net_income, :net_margin)  
  
  def initialize(periods, company)
    @periods = periods 
    @company = company
    @period_set = []

    
    # figure out the period type by the number of items in the period
    # year will be 3
    # months will be 12
    # quarters will be 4
    
    @periods.each do |p|
      record = self.get_summary_data(@company, p)[0]
      custom = self.get_custom_fields(@company, p)
      ops_data = self.get_operational_data(@company, p)[0]
      #assign the return values to a data structure like a struct or a hash
      begin
        @bookings                 = record['bookings'] || 0
        @revenue                  = record['revenue'] || 0
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
      end
        @cash_burn                = ops_data['cash_burn'] || 0
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
     
        @period_set << PeriodSet.new(@gross_margin, @operating_margin, @cash_burn, p.first.year, p, @bookings, @revenue, @revenue_line_items, @cogs, @cogs_line_items, @gross_profit, @operating_expenses, @sga, @r_and_d, @total_operating_expenses, @expense_line_items, @operating_profit, @interest_income, @other_income, @tax_expense, @misc_line_items, @total_miscellaneous, @net_income, @net_margin)
    end
  end
  
end