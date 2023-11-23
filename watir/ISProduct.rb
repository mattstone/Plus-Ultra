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

    link = @browser.link(href: '/admin/products')
    link.click
    @browser.wait_until { @browser.text.include? 'Products' }
    good("browsed to admin/products")
    
    link = @browser.link(href: '/admin/products/new')
    link.click
    @browser.wait_until { @browser.text.include? 'New Product' }
    good("browsed to admin/products/new")
    
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

    @browser.scroll.to :bottom
    
    sleep 2

    javascript_script = "document.getElementById('product_teaser_trix_input_product').value = '<div>#{test_product[:teaser]}</div>'"
    @browser.execute_script(javascript_script)
     
    javascript_script = "document.getElementById('product_description_trix_input_product').value = '<div>#{test_product[:description]}</div>'"
    @browser.execute_script(javascript_script)

    checkbox = @browser.checkbox(id: 'product_for_sale')
    checkbox.set

    @browser.button(:id => "admin_products_update_button").click
    @browser.wait_until { @browser.text.include? 'Product was successfully created' }
    good("product created")
    
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
    
    link = @browser.link(href: "/admin/products/#{product.id}/edit")
    link.click
    
    @browser.wait_until { @browser.text.include? 'Edit Product' }
    good("browsed to admin/products")
    
    text_field = @browser.text_field(id: 'product_name')
    text_field.value = changed

    @browser.scroll.to :bottom
    sleep 1

    @browser.button(:id => "admin_products_update_button").click
    @browser.wait_until { @browser.text.include? 'Product was successfully updated' }
    good("product updated")
  end
  
  
  def create_subscription 
    
    link = @browser.link(href: "/admin/products")
    link.click
    
    @browser.wait_until { @browser.text.include? 'Manage Products' }
    good("browsed to manage products")
    
    link = @browser.link(href: "/admin/products/new")
    link.click
    
    @browser.wait_until { @browser.text.include? 'New Product' }
    good("browsed to admin/products/new")
    
    sleep 2 # Give javascript time to set the page up..
    
    
    text_field = @browser.text_field(id: 'product_name')
    text_field.value = test_subscription[:name]

    text_field = @browser.text_field(id: 'product_sku')
    text_field.value = test_subscription[:sku]

    text_field = @browser.text_field(id: 'product_price_in_cents')
    text_field.value = test_subscription[:price_in_cents]
    
    @browser.scroll.to :bottom
    
    sleep 1
    
    dropdown = @browser.select(id: 'product_purchase_type')
    dropdown.select(value: 'subscription')
    #     
    dropdown = @browser.select(id: 'product_billing_type')
    dropdown.select(value: 'monthly')
    
    checkbox = @browser.checkbox(id: 'product_for_sale')
    checkbox.set

    @browser.button(:id => "admin_products_update_button").click
    @browser.wait_until { @browser.text.include? 'Product was successfully created' }
    good("product created")
    
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
