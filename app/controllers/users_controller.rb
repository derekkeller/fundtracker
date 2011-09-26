class UsersController < ApplicationController
  before_filter :authenticate_user, :set_tab_active

  def index
    @links = {'Add User' => new_admin_user_path}
    @users = current_user.fund.users + current_user.fund.company_users
    @breadcrumb_trail = "User List"
  end
  
  def new
    @user = User.new
  end
  
  def create
    # validate company
    # generate password and maybe email it to the user
    @user = User.new(params[:user])
    @user.password = generate_password
    puts "**********" + @user.password + "**********"
        
    if @user.save 
      flash[:notice] = "User successfully created..."
      redirect_to users_path
    else
      @links = {'User List' => users_path}
      render :new
    end
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to users_path
    else
      @links = {'User List' => users_path}
      render :edit
    end
  end
  
  def edit
    @links = {'User List' => users_path}
    @user = User.find(params[:id])
    @breadcrumb_trail = "Editing #{@user}"
  end
  
  def edit_profile
    @links = {'User List' => users_path}
    @user = User.find(params[:user_id])
    @breadcrumb_trail = "Editing profile for #{@user}"
    if params[:user_id].to_i != session[:user_id]
      flash[:alert] = "You are not allowed to edit the profile of someone else"
      redirect_to users_path
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
      redirect_to users_path
    else
      @links = {'User List' => users_path}
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
  
  def generate_password
    source_characters = "0a1b2c4d3e5f6g7h8i9jklmnopqrstuvwxyz" 
    password = "" 
    1.upto(8) { password += source_characters[rand(source_characters.length),1] }
    return password
  end
  
end
