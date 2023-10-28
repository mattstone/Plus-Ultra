class Admin::DashboardController < Admin::BaseController
  
  def index 
  end 
  
  def logout
    log_out_current_user
  end
  
end
