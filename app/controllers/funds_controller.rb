class FundsController < ApplicationController
  before_filter :authenticate_user, :set_tab_active
  
  def index
    @companies = current_user.fund
    @breadcrumb_trail = "FUND"
  end

private
  def set_tab_active
    @fund_class = 'active'
  end
end
