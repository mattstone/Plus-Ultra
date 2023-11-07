class HasManyThroughRepair < ActiveRecord::Migration[7.0]
  def change
    rename_column :product_orders, :orders_id, :order_id
    rename_column :product_orders, :products_id, :product_id
  end
end
