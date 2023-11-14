class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  layout 'admin'

  private
  
  def check_admin
    log_out_current_user if !current_user.role_admin?
  end 
  
  def log_out_current_user 
    sign_out current_user
    flash[:notice] = "You have been successfully signed out."
    redirect_to root_path and return
  end
  
end
