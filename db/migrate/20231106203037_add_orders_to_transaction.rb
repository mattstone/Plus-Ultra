class AddOrdersToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :order_id, :integer    
    add_column :orders, :user_id, :integer
    
    remove_column :transactions, :product_id
    
    add_index :transactions, :order_id
    add_index :orders, :user_id
  end
end
