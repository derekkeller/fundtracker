module PeriodSummary
  def total_sub_total(rev, array)
    sum = 0.0
    begin
      array.each do |h|
        sum += h['positive']
        sum -= h['negative']
      end
    rescue
    end
    sum += rev
  end
  
  def total_sub_total_exp(rev, array)
    sum = 0.0
    begin
      array.each do |h|
        sum -= h['positive']
        sum += h['negative']
      end
    rescue
    end
    sum += rev
  end
  
  def get_operational_data(company, period)
    PeriodResult.connection.select_all("SELECT 
                                          sum(cash_burn) cash_burn 
                                        FROM operationals 
                                        WHERE company_id=#{company.id} 
                                          AND period_end BETWEEN '#{period[0]}' AND '#{period[1]}'")
    
  end
  
  def get_summary_data(company, period)
    PeriodResult.connection.select_all("SELECT 
                                          sum(bookings) bookings, 
                                          sum(revenue) revenue, 
                                          sum(cogs) cogs, 
                                          sum(operating_expenses) operating_expenses, 
                                          sum(sg_and_a) sga, 
                                          sum(r_and_d) r_and_d, 
                                          sum(depreciation) depreciation, 
                                          sum(amortization) amortization, 
                                          sum(interest_income) interest_income, 
                                          sum(other_income) other_income, 
                                          sum(other_expense) other_expense, 
                                          sum(tax_expense) tax_expense 
                                        FROM period_results 
                                        WHERE company_id=#{company.id} AND period between '#{period[0]}' AND '#{period[1]}' 
                                        GROUP BY company_id")
  end
  
  def get_custom_fields(company, period)
    results = []
    # Custom Revenue 
    results[0] = PeriodResult.connection.select_all("SELECT 
                                                        u.id,
                                                        u.name, 
                                                        sum(if(u.sign=1,c.amount,0)) positive,
                                                        sum(if(u.sign=2,c.amount,0)) negative,
                                                        u.id
                                                     FROM 
                                                      custom_cells c 
                                                      inner join period_results p on c.period_result_id=p.id  
                                                      inner join user_defined_categories u on u.id = c.user_defined_category_id 
                                                     WHERE
                                                      p.company_id=#{company.id} 
                                                      AND period between '#{period[0]}' AND '#{period[1]}'
                                                      AND u.c_type=1 
                                                     GROUP BY u.id")
    # Custom Cogs                                                 
    results[1] = PeriodResult.connection.select_all("SELECT
                                                        u.id,
                                                        u.name, 
                                                        sum(if(u.sign=1,c.amount,0)) positive,
                                                        sum(if(u.sign=2,c.amount,0)) negative 
                                                     FROM 
                                                      custom_cells c 
                                                      inner join period_results p on c.period_result_id=p.id  
                                                      inner join user_defined_categories u on u.id = c.user_defined_category_id 
                                                     WHERE
                                                      p.company_id=#{company.id} 
                                                      AND period between '#{period[0]}' AND '#{period[1]}'  
                                                      AND u.c_type=2 
                                                     GROUP BY u.id")
    # Custom expenses
    results[2] = PeriodResult.connection.select_all("SELECT 
                                                       u.id,
                                                       u.name, 
                                                       sum(if(u.sign=1,c.amount,0)) positive,
                                                       sum(if(u.sign=2,c.amount,0)) negative
                                                     FROM 
                                                       custom_cells c 
                                                       inner join period_results p on c.period_result_id=p.id  
                                                       inner join user_defined_categories u on u.id = c.user_defined_category_id 
                                                     WHERE
                                                       p.company_id=#{company.id} 
                                                       AND period between '#{period[0]}' AND '#{period[1]}'
                                                       AND u.c_type=3 
                                                     GROUP BY u.id")
    # Custom Misc                                                
    results[3] = PeriodResult.connection.select_all("SELECT
                                                       u.id,
                                                       u.name, 
                                                       sum(if(u.sign=1,c.amount,0)) positive,
                                                       sum(if(u.sign=2,c.amount,0)) negative 
                                                     FROM 
                                                       custom_cells c 
                                                       inner join period_results p on c.period_result_id=p.id  
                                                       inner join user_defined_categories u on u.id = c.user_defined_category_id 
                                                     WHERE
                                                       p.company_id=#{company.id} 
                                                       AND period between '#{period[0]}' AND '#{period[1]}'
                                                       AND u.c_type=4 
                                                     GROUP BY u.id")                                                    
   return results

  end
end