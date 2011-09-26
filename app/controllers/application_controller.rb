class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authenticate_user
    @user = User.find_active_user(session[:user_id])
  rescue
    flash[:alert] = "Please log in!"
    redirect_to log_in_path
    return false
  end
  
  def is_admin_user
    @user = User.find_active_user(session[:user_id])
    unless @user.is_admin?
      raise
    end
  rescue
    flash[:alert] = "You are not an admin user"
    redirect_to root_url
    return false
  end
  
  def current_user
    User.find(session[:user_id])
  end
  
  helper_method :current_user
  
  def set_period(n = nil)
    session[:period] ||= Date.today
    unless n.nil?
      # here we may need to account for the last day of the month or the current date is the period is the current month
      # We should probably set the date to the last day of the given period unless that period is today/current month
      
      session[:period] = session[:period].months_since(n)
      
      if session[:period].month == Date.today.month && session[:period].year == Date.today.year
        session[:period] = Date.today
      else
        session[:period] = session[:period].end_of_month
      end
    end
  end
  
  def reset_period
    session[:period] = Date.today
  end
  
  def get_view_by
    session[:view_by] ||= 'quarter'
  end
  
  def get_view_type
    session[:view_type] ||= 'actual'
  end
  
  def get_quarters(period)
    # We need to figure out which 4 quarters we are dealing with
    # There should be a matrix to see what the start and end dates are 
    # to the quarters
    # We'll count back four from the current period and grab the
    # correct data for each
    q4 = period.beginning_of_quarter
    q3 = (q4 - 1).beginning_of_quarter
    q2 = (q3 - 1).beginning_of_quarter
    q1 = (q2 - 1).beginning_of_quarter
    [
      [q1, q1.end_of_quarter],
      [q2, q2.end_of_quarter],
      [q3, q3.end_of_quarter],
      [q4, q4.end_of_quarter]
    ]
  end
  
  def get_months(period)
    months = []
    months[0] = [period.beginning_of_month, period.end_of_month]
    11.times do
      months << [months.last[1].months_ago(1).beginning_of_month, months.last[1].months_ago(1).end_of_month]
    end
    return months.reverse
  end
  
  def get_years(period)
    years = []
    years[0] = [period.beginning_of_year, period.end_of_year]
    2.times do
      years << [years.last[0].years_ago(1), years.last[1].years_ago(1)]
    end
    return years.reverse
  end
  
  def crement_period(crement, major = '0')
    case session[:view_by]
    when 'year'
      if crement == '1'
        session[:period] += 1.year
      else
        session[:period] -= 1.year
      end
    when 'month'
      if major == '1'
        if crement == '1'
          session[:period] += 1.year
        else
          session[:period] -= 1.year
        end
      else
        if crement == '1'
          session[:period] += 1.month
        else
          session[:period] -= 1.month
        end
      end
    else 
      if major == '1'
        if crement == '1'
          session[:period] += 1.year
        else
          session[:period] -= 1.year
        end
      else
        if crement == '1'
          session[:period] = session[:period].end_of_quarter + 1
        else
          session[:period] = session[:period].beginning_of_quarter - 1
        end
      end
    end
  end
  
  def set_period_type(p)
    case p
    when '1'
      session[:view_by] = 'year'
    when '3'
      session[:view_by] = 'month'
    else
      session[:view_by] = 'quarter'
    end
  end
  
  def set_view_type(v)
    case v
    when '1'
      session[:view_type] = 'actual'
    when '2'
      session[:view_type] = 'forecast'
    when '3'
      session[:view_type] = 'variance'
    when '4'
      session[:view_type] = 'growth'
    when '5'
      session[:view_type] = 'sales'
    end
  end
  
  def reset_company_session
    session[:company_id] = nil
  end
  
  def reset_fund_session
    session[:fund_id] = nil
    reset_company_session
  end

  def reset_organization_session
    session[:organization_id] = nil
    reset_fund_session
  end
  
end
