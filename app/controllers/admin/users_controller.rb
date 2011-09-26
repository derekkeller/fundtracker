class Admin::UsersController < ApplicationController
  layout 'admin'
  before_filter :is_admin_user, :set_tab_active
  
  def index
    @links = {'Add User' => new_admin_user_path}
    @users = User.all
    @breadcrumb_trail = "User List"
  end
  
  def new
    # if there are no funds we need to let them know to set up
    # a fund before adding users
    if Fund.all.size > 0
      @links = {'User List' => admin_users_path}
      @user = User.new
      @breadcrumb_trail = "Adding a User"
    else
      flash[:alert] = "A fund must be created before users can be added."
      redirect_to new_admin_fund_path
    end
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save 
      flash[:notice] = "User successfully created..."
      redirect_to admin_users_path
    else
      @links = {'User List' => admin_users_path}
      render :new
    end
  end
  
  def edit
    @links = {'User List' => admin_users_path}
    @user = User.find(params[:id])
    @breadcrumb_trail = "Editing #{@user}"
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to admin_users_path
    else
      @links = {'User List' => admin_users_path}
      render :edit
    end
  end
  
  def edit_profile
    @links = {'User List' => admin_users_path}
    @user = User.find(params[:user_id])
    @breadcrumb_trail = "Editing profile for #{@user}"
    if params[:user_id].to_i != session[:user_id]
      flash[:alert] = "You are not allowed to edit the profile of someone else"
      redirect_to admin_users_path
    end
  end
  
  def update_profile
    
    @user = User.find(params[:user_id])
    
    unless params[:password].empty?
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
    end
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated"
      redirect_to admin_users_path
    else
      @links = {'User List' => admin_users_path}
      render :edit_profile
    end
  end
  
private
  def set_tab_active
    if ['edit_profile', 'update_profile'].include?(action_name)
      @profile_class = 'active'
    else
      @users_class = 'active'
    end 
  end

end