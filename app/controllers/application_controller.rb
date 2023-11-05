class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_shopping_cart
  
  def l(string)
    Rails.logger.info string.to_s.yellow
  end

  #
  # Devise callbacks
  #

  def after_sign_in_path_for(resource)
    if resource.class.to_s == "User"
      return admin_dashboard_path if resource.admin?
    end
    root_url
  end


  protected
  
  def set_shopping_cart 
    session[:shopping_cart] ||= {}
    @shopping_cart = session[:shopping_cart]
  end

  def configure_permitted_parameters
    attributes = [:first_name, :last_name, :email, :avatar]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    #devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end  
  
  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :role,
      :stripe_customer_id,
      :password,
      :password_confirmation
    )
  end
  
  
end
