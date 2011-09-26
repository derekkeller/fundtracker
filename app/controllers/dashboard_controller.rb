class DashboardController < ApplicationController
  before_filter :authenticate_user, :set_tab_active
  
  def index

  end


private
  def set_tab_active
    @dashboard_class = 'active'
    @breadcrumb_trail = 'Dashboard'
  end

end
