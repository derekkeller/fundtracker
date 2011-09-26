class Admin::UserDefinedCategoriesController < ApplicationController
  layout 'admin'
  before_filter :is_admin_user, :set_tab_active
  
  def new
    @user_defined_category = UserDefinedCategory.new
    @links = {'Company Edit' => edit_admin_company_path(params[:company_id])}
    @company = Company.find(params[:company_id])
    @breadcrumb_trail = "#{@company.fund} > #{@company} > New User Defined Category"
  end
  
  def create
    @company = Company.find(params[:company_id])

    @user_defined_category = @company.user_defined_categories.build(params[:user_defined_category])
    
    if @user_defined_category.save
      flash[:notice] = "User Defined Category added!"
      redirect_to admin_company_user_defined_categories_path(@company)
    else
      @links = {'Company Edit' => edit_admin_company_path(@company)}
      @breadcrumb_trail = "#{@company.fund} > #{@company} > New User Defined Category"
      render :new
    end
  end
  
  def edit
    @company = Company.find(params[:company_id])
    @user_defined_category = UserDefinedCategory.find(params[:id])
    @links = {'Company Edit' => edit_admin_company_path(@company)}
    @breadcrumb_trail = "#{@company.fund} > #{@company} > Edit User Defined Category"
  end
  
  def update
    @user_defined_category = UserDefinedCategory.find(params[:id])
    @company = Company.find(params[:company_id])
    
    if @user_defined_category.update_attributes(params[:user_defined_category])
      flash[:notice] = "User Defined Category updated"
      redirect_to admin_company_user_defined_categories_path(@company)
    else
      @breadcrumb_trail = "#{@company.fund} > #{@company} > Edit User Defined Category"
      @links = {"Edit Company" => edit_admin_company_path(@company)}
      render :edit
    end
  end
  
  def index
    @company = Company.find(params[:company_id])
    @links = {"Add User defined category" => new_admin_company_user_defined_category_path(@company)}    
  end
  
private
  def set_tab_active
    @funds_class = 'active'
  end

end
