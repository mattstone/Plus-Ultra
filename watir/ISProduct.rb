require File.join(__dir__, "./ISBaseWatir.rb")

class ISProduct < ISBaseWatir
  
  def initialize 
    super
    
    remove_test_data!
    create_and_confirm_admin_user!
    
    sign_in_admin
    
    create_product
    update_product

  end
  
  
  def remove_test_data!
    Product.where(name: test_product[:name]).destroy_all
    Product.where(name: "Changed").destroy_all
  end 
  
  def test_product 
    {
      name: "Test product",
      sku: "12345",
      price_in_cents: 2000,
      purchase_type: "purchase",
      billing_type: "once_off",
      teaser: "Teaser",
      description: "Description"
    }
  end 
  
  def test_product_record 
    product = Product.find_by(name: test_product[:name])
    product = Product.find_by(name: "Changed") if product.nil?
    product
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

    @browser.button(:id => "admin_products_update_button").click
    @browser.wait_until { @browser.text.include? 'Product was successfully created' }
    good("product created")

  end
  
  def update_product 
    header("Update Product")
    
    product = test_product_record
    
    link = @browser.link(href: "/admin/products/#{product.id}/edit")
    link.click
    
    @browser.wait_until { @browser.text.include? 'Edit Product' }
    good("browsed to admin/products")
    
    text_field = @browser.text_field(id: 'product_name')
    text_field.value = "Changed"

    @browser.scroll.to :bottom
    sleep 1

    @browser.button(:id => "admin_products_update_button").click
    @browser.wait_until { @browser.text.include? 'Product was successfully created' }
    good("product updated")

    sleep 980
  end

  
end

ISProduct.new
