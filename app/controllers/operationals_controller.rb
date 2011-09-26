class OperationalsController < ApplicationController
  require 'operational_summary'
  
  before_filter :authenticate_user, :set_tab_active
  
  def new
    @operational = Operational.new
    @company = Company.find(params[:company_id])
    
  end

  def edit
  end

  def index
    @view_by = get_view_by()
    @view_type = get_view_type()
    @company = Company.find(params[:company_id])
    @breadcrumb_trail = "PORTFOLIO > #{@company.name.upcase} > OPERATIONALS"
    
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
      @operational_summary = OperationalSummary.new(@periods, @company)
    # we should make a lib to gather the info by periods
  end
  
  def change_period
    set_period_type(params[:operational_id])
    
    redirect_to :action => :index, :company_id => params[:company_id]
  end
  
  def move_through_time
    # based on the  view_by we advance a month, 3 months, or a year
    #params[:id] = 1 for increment 0 for decrement
    crement_period(params[:operational_id], params[:major])
    
    redirect_to :action => :index, :company_id => params[:company_id]
  end
  
private
  def set_tab_active
    @portfolio_class = 'active'
    this_year = Date.today.year
    @years = [this_year - 2, this_year - 1, this_year]
  end
  
end
