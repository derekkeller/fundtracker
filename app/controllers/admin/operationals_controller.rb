class Admin::OperationalsController < ApplicationController
  layout 'admin'
  before_filter :is_admin_user, :set_tab_active
  
  def new
    @links = {'Company Edit' => edit_admin_company_path(params[:company_id])}
    @operational = Operational.new
    @company = Company.find(params[:company_id])
    @breadcrumb_trail = "#{@company.fund} > #{@company} > New Operational Data"
  end

  def create
    @company = Company.find(params[:company_id])
    
    @operational = @company.operationals.build(params[:operational])
    
    if @operational.save
      flash[:notice] = "Operational data added!"
      redirect_to admin_company_operationals_path(@company)
    else
      @links = {'Company Edit' => edit_admin_company_path(@company)}
      @breadcrumb_trail = "#{@company.fund} > #{@company} > New Operational Data"
      render :new
    end
  end

  def edit
    @operational = Operational.find(params[:id])
    @links = {'Company Edit' => edit_admin_company_path(@operational.company)}
    @breadcrumb_trail = "#{@operational.company.fund} > #{@operational.company} > Editing #{@operational} period"
  end
  
  def update
    @operational = Operational.find(params[:id])
    
    if @operational.update_attributes(params[:operational])
      flash[:notice] = "Operational period saved!"
      redirect_to edit_admin_company_path(@operational.company)
    else
      render :edit
    end
  end

  def index
    @company = Company.find(params[:company_id])
    @links = {'Add operational data' => new_admin_company_operational_path(@company)}
  end

private
  def set_tab_active
    @funds_class = 'active'
  end
    
end
