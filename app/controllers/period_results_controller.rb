class PeriodResultsController < ApplicationController
  require 'year_summary'
  require 'operational_summary'
  require 'operational_forecast_summary'
  require 'sales_percentage_summary'
  
  before_filter :authenticate_user, :set_tab_active
  
  def new
  end

  def edit
  end

  def index
    @view_by = get_view_by()
    @view_type = get_view_type()
    
    @company = Company.find(params[:company_id])
    @breadcrumb_trail = "PORTFOLIO > #{@company.name.upcase} > FINANCIAL"
    
    case @view_by
    when 'quarter'
      @periods = get_quarters(session[:period])
      @header_row_partial = 'quarterly_header'
    when 'month'
      @periods = get_months(session[:period])
      @header_row_partial = 'monthly_header'
    when 'year'
      @periods = get_years(session[:period])
      @header_row_partial = 'yearly_header'
    end
    
    case @view_type
    when 'forecast'
      @operational_summary = OperationalForecastSummary.new(@periods, @company)
    when 'sales'
      @operational_summary = SalesPercentageSummary.new(@periods, @company)
    else # actuals
      @operational_summary = OperationalSummary.new(@periods, @company)
    end
  end
  
  def change_period
    set_period_type(params[:period_result_id])
    
    redirect_to :action => :index, :company_id => params[:company_id]
  end
  
  def move_through_time
    # based on the  view_by we advance a month, 3 months, or a year
    #params[:id] = 1 for increment 0 for decrement
    crement_period(params[:period_result_id], params[:major])
    
    redirect_to :action => :index, :company_id => params[:company_id]
  end
  
  def change_view_type
    set_view_type(params[:period_result_id])
    
    redirect_to :action => :index, :company_id => params[:company_id]
  end

private
  def set_tab_active
    @portfolio_class = 'active'
    this_year = Date.today.year
    @years = [this_year - 2, this_year - 1, this_year]
  end

end
