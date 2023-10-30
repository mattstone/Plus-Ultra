class AddFieldsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :price, :integer, default: 0
    add_column :products, :purchase_type, :integer, default: 0
    add_column :products, :billing_type,  :integer, default: 0
    
    add_index :products, :name
    add_index :products, :sku
  end
end
