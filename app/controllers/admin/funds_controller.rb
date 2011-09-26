class Admin::FundsController < ApplicationController
  layout 'admin'
  before_filter :is_admin_user, :set_tab_active
  
  def new
    @links = {"Fund List" => admin_organization_funds_path}
    @organization = Organization.find(params[:organization_id])
    @fund = @organization.funds.new
    @breadcrumb_trail = "New Fund"
  end

  def show
    @fund = Fund.find(params[:id])
    session[:fund_id] = params[:id]
    session[:company_id] = nil
    @organization = @fund.organization
  end
  
  def create
    @organization = Organization.find(params[:organization_id])
    @fund = @organization.funds.build(params[:fund])
    
    if @fund.save 
      flash[:notice] = "Fund successfully created..."
      redirect_to admin_organization_path(@organization)
    else
      @links = {"Fund List" => admin_organization_funds_path}
      render :new
    end
  end
  
  def index
    @organization = Organization.find(params[:organization_id])
    session[:fund_id] = nil
    session[:company_id] = nil
    @funds = @organization.funds.active
    @links = {"Add Fund" => new_admin_organization_fund_path}
    @breadcrumb_trail = "Fund list"
  end
  
  def edit
    @organization = Organization.find(params[:organization_id])
    @fund = @organization.funds.find(params[:id])
    reset_company_session
    @links = {"Add Fund" => new_admin_organization_fund_path, "Fund List" => admin_organization_funds_path}
    @breadcrumb_trail = "Editing #{@fund}"
  end
  
  def update
    @organization = Organization.find(params[:organization_id])
    @fund = @organization.funds.find(params[:id])
    
    if @fund.update_attributes(params[:fund])
      flash[:notice] = "Fund updated"
      redirect_to admin_organization_fund_path(@organization,@fund)
    else
      @links = {"Add Fund" => new_admin_fund_path}
      render :edit
    end
    
  end

private
  def set_tab_active
    @funds_class = 'active'
  end
end
