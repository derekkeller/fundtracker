class Admin::ForecastsController < ApplicationController
  layout 'admin'
  before_filter :is_admin_user, :set_tab_active
  
  def index
    @company = Company.find(params[:company_id])
    @links = {'Add Forecast Data' => new_admin_company_forecast_path(@company)}
  end
  
  def new
    @links = {'Company Edit' => edit_admin_company_path(params[:company_id])}
    @forecast = Forecast.new
    @company = Company.find(params[:company_id])
    @revenue, @cogs, @operating_exp, @other = [],[],[],[]
    @company.user_defined_categories.each do |c|
      @forecast.custom_cells 
      @revenue << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 1
      @cogs << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 2
      @operating_exp << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 3
      @other << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 4
    end

    @breadcrumb_trail = "#{@company.fund} > #{@company} > New Forecast Data"
  end
  
  def create
    @company = Company.find(params[:company_id])
    
    @forecast = @company.forecasts.build(params[:forecast])
    
    if @forecast.save
      flash[:notice] = "Forecast data added!"
      redirect_to admin_company_forecasts_path(@company)
    else
      @links = {'Company Edit' => edit_admin_company_path(@company)}
      @breadcrumb_trail = "#{@company.fund} > #{@company} > New Forecast Data"
      render :new
    end
  end
  
  def edit
    @forecast = Forecast.find(params[:id])
    @company = Company.find(params[:company_id])
    @links = {'Company Edit' => edit_admin_company_path(@forecast.company)}
    @breadcrumb_trail = "#{@forecast.company.fund} > #{@forecast.company} > Editing Forecast period #{@forecast}"
    @revenue, @cogs, @operating_exp, @other = [],[],[],[]
    @company.user_defined_categories.each do |c|
      @forecast.custom_cells 
      @revenue << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 1
      @cogs << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 2
      @operating_exp << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 3
      @other << CustomCell.new(:user_defined_category_id => c.id, :amount => 0) if c.c_type == 4
    end
  end
  
  def update
    @forecast = Forecast.find(params[:id])
    
    if @forecast.update_attributes(params[:forecast])
      flash[:notice] = "Forecast period saved!"
      redirect_to admin_company_forecasts_path(@forecast.company)
    else
      @links = {'Company Edit' => edit_admin_company_path(@forecast.company)}
      @breadcrumb_trail = "#{@forecast.company.fund} > #{@forecast.company} > Editing Forecast period #{@forecast}"
      render :edit
    end
  end
private

  def set_tab_active
    @funds_class = 'active'
  end
end
