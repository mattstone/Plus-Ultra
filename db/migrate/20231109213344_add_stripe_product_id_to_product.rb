class AddStripeProductIdToProduct < ActiveRecord::Migration[7.0]
  def change
    
    add_column :products, :stripe_product_id, :string
    
    add_index  :products, :stripe_product_id
  end
end
