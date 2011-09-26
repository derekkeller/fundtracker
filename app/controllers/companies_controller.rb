class CompaniesController < ApplicationController
  require 'year_summary'
  before_filter :authenticate_user, :set_tab_active
  
  def index
    @companies = current_user.company_array
    @breadcrumb_trail = "PORTFOLIO > SUMMARY"
    @company_sub_nav_style = 'display: none;'
  end

  def new
  end

  def edit
  end
  
  def show
    @company = Company.find(params[:id])
    @year1 = YearSummary.new(@company, Date.today.year)
    @year2 = YearSummary.new(@company, Date.today.year - 1)
    @year3 = YearSummary.new(@company, Date.today.year - 2)
    @precision = 0
    @breadcrumb_trail = "PORTFOLIO > #{@company.name.upcase} > FINANCIAL"
  end

private
  def set_tab_active
    @portfolio_class = 'active'
  end
end
