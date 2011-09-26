class Admin::SeriesController < ApplicationController
  layout 'admin'
  before_filter :is_admin_user, :set_tab_active
  
  def new
    @links = {'Company Edit' => edit_admin_company_path(params[:company_id])}
    @series = Series.new
    @company = Company.find(params[:company_id])
    @breadcrumb_trail = "#{@company.fund} > #{@company} > New Investment Series"
  end

  def create
    @company = Company.find(params[:company_id])
    
    @series = @company.series.build(params[:series])
    
    if @series.save
      flash[:notice] = "Series added!"
      redirect_to admin_company_series_index_path(@company)
    else
      @links = {'Company Edit' => edit_admin_company_path(@company)}
      @breadcrumb_trail = "#{@company.fund} > #{@company} > New Investment Series"
      render :new
    end
  end

  def index
    @company = Company.find(params[:company_id])
    @links = {"Add Series" => new_admin_company_series_path(@company)}
  end

  def edit
    @links = {'Company Edit' => edit_admin_company_path(params[:company_id])}
    @series = Series.find(params[:id])
  end
  
  def update
    @series = Series.find(params[:id])
    
    if @series.update_attributes(params[:series])
      flash[:notice] = "Series saved!"
      redirect_to edit_admin_company_path(@series.company)
    else
      render :edit
    end
  end

private
  def set_tab_active
    @funds_class = 'active'
  end
end
