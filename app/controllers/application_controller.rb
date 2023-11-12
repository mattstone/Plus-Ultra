class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_shopping_cart
  before_action :set_seo
  
  def l(string)
    case Rails.env.test?
    when true  then Rails.logger.debug(string.to_s.yellow)
    when false then Rails.logger.info(string.to_s.yellow)
    end
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
  
  def add_product_to_shopping_cart(product, subscription = false)
    return if product.purchase_type_subscription? and !subscription # Don't add subscriptions to shopping cart
    
    if session[:shopping_cart]["#{product.id}"]
      session[:shopping_cart]["#{product.id}"]["count"] += 1
    else 
      session[:shopping_cart]["#{product.id}"] = { name: product.name, count: 1 }
    end
  end
  
  def clear_shopping_cart 
    session[:shopping_cart] = nil
    set_shopping_cart
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
  
  def set_seo
    @title = "Starter - #{params[:controller]}  #{params[:action]}"
    @meta_description = "#{params[:controller]}  #{params[:action]}"
    @meta_keywords    = "Starter, #{params[:controller]}, #{params[:action]}}"
  end
  
end
