require File.join(__dir__, "./ISBaseWatir.rb")

class ISProduct < ISBaseWatir
  
  def initialize 
    super
    
    remove_test_data!
    create_and_confirm_admin_user!
    
    sign_in_admin
    
    create_product
    update_product
    
    remove_test_data!
    create_subscription

    tests_complete
  end
  
  
  def remove_test_data!
    Product.where(name: test_product[:name]).destroy_all
    Product.where(name: changed).destroy_all
    Product.where(name: test_subscription[:name]).destroy_all
  end   
  
  def create_product 
    header("Create Product")

    click '/admin/products'
    
    wait_for_text 'Products'
    
    click '/admin/products/new'

    wait_for_text 'New Product'
    
    sleep 2 # Give javascript time to set the page up..
    
    text_field = @browser.text_field(id: 'product_name')
    text_field.value = test_product[:name]

    text_field = @browser.text_field(id: 'product_sku')
    text_field.value = test_product[:sku]

    text_field = @browser.text_field(id: 'product_price_in_cents')
    text_field.value = test_product[:price_in_cents]

    string = File.join(__dir__,'./images/')
    string += "Test_heic.HEIC"

    @browser.file_field.set(string)

    scroll_to_bottom(2)
    
    execute_javascript("document.getElementById('product_teaser_trix_input_product').value = '<div>#{test_product[:teaser]}</div>'")

    execute_javascript("document.getElementById('product_description_trix_input_product').value = '<div>#{test_product[:description]}</div>'")
     
    checkbox = @browser.checkbox(id: 'product_for_sale')
    checkbox.set

    click_button "admin_products_update_button"
    
    wait_for_text 'Product was successfully created'
    
    sleep 2
    
    product = test_product_record
    
    case !product.stripe_product_id.blank?
    when true  then good("stripe_product_id ok")
    when false then bad("stripe_product_id not ok")
    end

    case !product.stripe_price_id.blank?
    when true  then good("stripe_price_id ok")
    when false then bad("stripe_price_id not ok")
    end

  end
  
  def update_product 
    header("Update Product")
    
    product = test_product_record
    
    click "/admin/products/#{product.id}/edit"
    
    wait_for_text 'Edit Product'
    
    text_field = @browser.text_field(id: 'product_name')
    text_field.value = changed

    scroll_to_bottom

    click_button "admin_products_update_button"
    
    wait_for_text 'Product was successfully updated'
  end
  
  
  def create_subscription 
    
    click "/admin/products"
    
    wait_for_text 'Manage Products'
    
    click "/admin/products/new"
    
    wait_for_text 'New Product'
    
    sleep 2 # Give javascript time to set the page up..
    
    text_field = @browser.text_field(id: 'product_name')
    text_field.value = test_subscription[:name]

    text_field = @browser.text_field(id: 'product_sku')
    text_field.value = test_subscription[:sku]

    text_field = @browser.text_field(id: 'product_price_in_cents')
    text_field.value = test_subscription[:price_in_cents]

    scroll_to_bottom
    
    set_select('product_purchase_type', 'subscription')

    set_select('product_billing_type', 'monthly')
    
    checkbox = @browser.checkbox(id: 'product_for_sale')
    checkbox.set

    click_button "admin_products_update_button"
    
    wait_for_text 'Product was successfully created'
    
    sleep 2 
    
    test_subscription_product = test_subscription_product_record
    
    case !test_subscription_product.stripe_product_id.blank?
    when true  then good("product.stripe_product_id has value")
    when false then good("product.stripe_product_id has no value")
    end

    case !test_subscription_product.stripe_price_id.blank?
    when true  then good("product.stripe_price_id has value")
    when false then good("product.stripe_price_id has no value")
    end
        
  end
  
  
end

ISProduct.new
