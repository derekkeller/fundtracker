class Admin::CustomCellsController < ApplicationController
  layout 'admin'
  before_filter :is_admin_user, :set_tab_active
  
  def new
    
  end
  
  def create
    
  end
  
  def edit
    
  end
  
  def update
    
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
