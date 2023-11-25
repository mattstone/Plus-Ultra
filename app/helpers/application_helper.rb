module ApplicationHelper
  
  def standard_button_class
    "btn btn-sm btn-primary"
  end 
  
  def admin_button_class
    "btn btn-sm btn-primary"
  end

  def admin_button_class_warning
    "btn btn-sm btn-warning"
  end
  
  def admin_header_class 
    "text-primary"
  end
  
  def admin_background_class 
    "p-3 mb-2 bg-primary text-white"
  end
  
  def dashboard_button_class 
    "btn btn-sm btn-primary"
  end
  
  
  def cents_to_dollars(amount_in_cents)
    number_to_currency(amount_in_cents / 100)
  end
  
  def short_date(date)
    date&.strftime("%d/%m/%Y")
  end

  def short_date_and_time(datetime)
    datetime&.strftime("%d/%m/%Y %H:%M %P %Z")
  end
    
  def current_page?(options)
    params[:controller] == options[:controller] and params[:action] == options[:action]
  end 
  
  def product_billing_string(product)
    "#{cents_to_dollars product.price_in_cents} #{product.pricing_string}"    
  end
  
  def qr_magic(text)
      # only load when needed
      require 'barby'
      require 'barby/barcode'
      require 'barby/barcode/qr_code'
      require 'barby/outputter/png_outputter'

      barcode = Barby::QrCode.new(text, level: :q, size: 10)
      base64_output = Base64.encode64(barcode.to_png({ xdim: 5 }))
      "data:image/png;base64,#{base64_output}"
    end  
  
end
