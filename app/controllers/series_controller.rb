class SeriesController < ApplicationController
  before_filter :authenticate_user, :set_tab_active
  
  def index
    @company = Company.find(params[:company_id])
    @breadcrumb_trail = "PORTFOLIO > #{@company.name.upcase} > SERIES"
    
    
  end
  
  def show
    
  end

private
  def set_tab_active
    @portfolio_class = 'active'
    this_year = Date.today.year
    @years = [this_year - 2, this_year - 1, this_year]
  end

end
