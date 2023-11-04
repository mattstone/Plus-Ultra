class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user 
      t.references :product 
      t.integer    :status, default: 0
      t.string     :token 
      t.integer    :price_in_cents
      t.json       :history, default: []
      t.timestamps
    end
    
    add_index :transactions, :status 
    add_index :blogs,        :title 
  end
end
