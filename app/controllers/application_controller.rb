class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def l(string)
    Rails.logger.info string.yellow
  end

  #
  # Devise callbacks
  #

  def after_sign_in_path_for(resource)
    return admin_dashboard_path if resource.role_admin?
    root_url
  end

  protected

  def configure_permitted_parameters
    attributes = [:first_name, :last_name, :email, :avatar]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    #devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end  
end
