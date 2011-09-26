class Admin::OrganizationsController < ApplicationController

  before_filter :set_tab_active

  layout 'admin'
  # before_filter :is_admin_user, :set_tab_active

  def index
    @organizations = Organization.all
    reset_organization_session
    @organization = nil
    @fund = nil
  end
  
  def show
    @organization = Organization.find(params[:id])
    session[:organization_id] = @organization.id
    reset_fund_session
    @funds = @organization.funds.order('start_date ASC')
    @fund = @organization
  end

  def new
    @organization = Organization.new
  end
  
  def create
    @organization = Organization.new(params[:organization])
    
    if @organization.save
      redirect_to admin_organizations_path
    else
      render :new
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end
  
  def update
    @organization = Organization.find(params[:id])
    
    if @organization.update_attributes(params[:organization])
      flash[:notice] = "Organization saved!"
      redirect_to edit_admin_organization_path(@organization)
    else
      render :edit
    end
  end
  
  def destroy
    @organization = Organization.find(params[:id])
    
    @organization.destroy
    
    redirect_to admin_organizations_path
  end 

private
  def set_tab_active
    @organizations_class = 'active'
  end
end