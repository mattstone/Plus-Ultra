class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_shopping_cart
  before_action :set_seo
  before_action :set_referrer
  
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
    dashboard_dashboard_path
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
    attributes = [:first_name, :last_name, :email, :avatar, :time_zone]
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
      :password_confirmation,
      :campaign_id,
      :time_zone
    )
  end
  
  def set_referrer
    # TODO: handle seach engine referrers 
    return if params[:tag].blank?
    session[:tag] = params[:tag]  # Overwrite any previous with latest
  end
  
  def request_ip_address
    request.env['HTTP_X_FORWARDED_FOR'].blank? ? request.remote_ip : request.env['HTTP_X_FORWARDED_FOR']
  end
  
  private 
  
  def set_seo
    @title = "#{ENV['APP_NAME']} - #{params[:controller]}  #{params[:action]}"
    @meta_description = "#{params[:controller]}  #{params[:action]}"
    @meta_keywords    = "#{ENV['APP_NAME']}, #{params[:controller]}, #{params[:action]}}"
  end
  
  def set_start_and_end_date
    @start_date = params[:start_date].blank? ? Time.now.beginning_of_day - 1.year : Date.parse(params[:start_date]).beginning_of_day
    @end_date   = params[:end_date].blank?   ? Time.now.end_of_day                : Date.parse(params[:end_date]).end_of_day
  end
  
  def cancel_subscription 
    stripe   = ISStripe.new 
    response = stripe.subscription_cancel(@subscription.stripe_subscription_id)

    case response["status"] == "canceled"
    when true  then @subscription.status_canceled!
    when false then @error = "Unable to cancel subscription. Status: #{response["status"]}"
    end
  end

  
end
