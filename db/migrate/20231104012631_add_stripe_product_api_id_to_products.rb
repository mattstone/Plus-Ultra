class AddStripeProductApiIdToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :stripe_product_api_id, :string, default: nil
  end
end
