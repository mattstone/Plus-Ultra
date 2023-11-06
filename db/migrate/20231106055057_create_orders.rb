class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :amount_in_cents

      t.timestamps
    end

    create_table :product_orders do |t|
      t.belongs_to :orders 
      t.belongs_to :products 
      t.integer :quantity
      t.integer :amount_in_cents

      t.timestamps
    end

  end
end
