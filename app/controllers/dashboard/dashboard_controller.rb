class Dashboard::DashboardController < Dashboard::BaseController
  before_action :set_time_zone, if: :current_user
  
  def index 
  end 
  
  def set_time_zone 
  end
  
end
