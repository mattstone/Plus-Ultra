class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_controller_and_action
  
  def l(string)
    Rails.logger.info string.to_s.yellow
  end

  #
  # Devise callbacks
  #

  def after_sign_in_path_for(resource)
    l "*****************************"
    l "after_sign_in_path_for"
    l "*****************************"
    l "resource.class: -#{resource.class}-"
    
    if resource.class.to_s == "User"
      return admin_dashboard_path if resource.admin?
    end
    root_url
  end

  protected
  
  def set_controller_and_action
    @controller = params[:controller]
    @action     = params[:action]
  end

  def configure_permitted_parameters
    attributes = [:first_name, :last_name, :email, :avatar]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    #devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end  
end
