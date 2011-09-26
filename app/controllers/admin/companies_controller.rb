class Admin::CompaniesController < ApplicationController
  require 'year_summary'
  require 'operational_summary'

  layout 'admin'
  before_filter :is_admin_user, :set_tab_active
  
  def new
    @organization = Organization.find(params[:organization_id])
    @fund = @organization.funds.find(params[:fund_id])
    @company = @fund.companies.build
    @breadcrumb_trail = "#{@fund} > New Company"
  end

  def show
    @organization = Organization.find(params[:organization_id])
    @fund = @organization.funds.find(params[:fund_id])
    @company = @fund.companies.find(params[:id])
    session[:company_id] = params[:id]
    session[:fund_id] = @fund.id
    @periods = get_years(session[:period])
    @operational_summary = OperationalSummary.new(@periods, @company)
  end
  
  def create
    @organization = Organization.find(params[:organization_id])
    @fund = @organization.funds.find(params[:fund_id])
    @company = @fund.companies.build(params[:company])
    
    if @company.save
      flash[:notice] = "Company added!"
      redirect_to admin_organization_fund_path(@organization, @fund)
    else
      render new_admin_organization_fund_company_path(@organization, @fund)
    end
  end
  
  def index
    if session[:fund_id].present?
      @fund = Fund.find(session[:fund_id])
      @organization = @fund.organization
      @companies = @fund.companies
    else
      @organization = Organization.find(session[:organization_id])
      @companies = @organization.companies
    end
  end

  def edit
    @organization = Organization.find(params[:organization_id])
    @fund = @organization.funds.find(params[:fund_id])
    @company = @fund.companies.find(params[:id])
    @links = {'Edit ' + @company.fund.to_s => edit_admin_organization_fund_path(@company.fund)}
  end

  def update
    @organization = Organization.find(params[:organization_id])
    @fund = @organization.funds.find(params[:fund_id])
    @company = @fund.companies.find(params[:id])
    
    if @company.update_attributes(params[:company])
      flash[:notice] = "Company saved!"
      redirect_to admin_organization_fund_company_path(@organization, @fund, @company)
    else
      render :edit
    end
  end

private
  def set_tab_active
    @funds_class = 'active'
    # @links = {'Fund List' => admin_organization_funds_path}
  end
end
