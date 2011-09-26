class Admin::PeriodResultsController < ApplicationController
  layout 'admin'
  before_filter :is_admin_user, :set_tab_active
  
  def new
    @links = {'Company Edit' => edit_admin_company_path(params[:company_id])}
    @period_result = PeriodResult.new
    @company = Company.find(params[:company_id])
    @revenue, @cogs, @operating_exp, @other = [],[],[],[]
    @company.user_defined_categories.each do |c|
      #@period_result.custom_cells 
      @revenue << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 1
      @cogs << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 2
      @operating_exp << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 3
      @other << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 4
    end

    @breadcrumb_trail = "#{@company.fund} > #{@company} > New Financial Data"
  end
  
  def create
    @company = Company.find(params[:company_id])

    @period_result = PeriodResult.new(params[:period_result].merge(:company_id => @company.id))
    @period_result.company_id = @company.id
    
    if @period_result.save
      flash[:notice] = "Financial data added!"
      redirect_to admin_company_period_results_path(@company)
    else
      @links = {'Company Edit' => edit_admin_company_path(@company)}
      @breadcrumb_trail = "#{@company.fund} > #{@company} > New Financial Data"
      render :new
    end
  end

  def edit
    @period_result = PeriodResult.find(params[:id])
    @company = Company.find(params[:company_id])
    @links = {'Company Edit' => edit_admin_company_path(@period_result.company)}
    @breadcrumb_trail = "#{@period_result.company.fund} > #{@period_result.company} > Editing Financial period #{@period_result}"
    @company.user_defined_categories.each do |c|
      @revenue = @period_result.custom_cells.where('user_defined_categories.c_type' => 1).includes('user_defined_category')
      @cogs = @period_result.custom_cells.where('user_defined_categories.c_type' => 2).includes('user_defined_category')
      @operating_exp = @period_result.custom_cells.where('user_defined_categories.c_type' => 3).includes('user_defined_category')
      @other = @period_result.custom_cells.where('user_defined_categories.c_type' => 4).includes('user_defined_category')
    end
  end
  
  def update
    @period_result = PeriodResult.find(params[:id])
    
    if @period_result.update_attributes(params[:period_result])
      flash[:notice] = "Financial period saved!"
      redirect_to admin_company_period_results_path(@period_result.company)
    else
      @links = {'Company Edit' => edit_admin_company_path(@period_result.company)}
      @breadcrumb_trail = "#{@period_result.company.fund} > #{@period_result.company} > Editing Financial period #{@period_result}"
      render :edit
    end
  end

  def index
    @company = Company.find(params[:company_id])
    @links = {'Add Financials' => new_admin_company_period_result_path(@company)}
  end

private
  def set_tab_active
    @funds_class = 'active'
  end
end

