class AddPriceInCentsToProductOrder < ActiveRecord::Migration[7.0]

  def change
    add_column :product_orders, :price_in_cents, :integer, default: 0
  end
  
end
