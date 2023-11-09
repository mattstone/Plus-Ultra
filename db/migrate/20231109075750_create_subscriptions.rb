class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user 
      t.belongs_to :product
      t.integer    :status
      t.timestamps
    end
    
    add_column :transactions, :subscription_id, :integer
    
    add_index :transactions, :subscription_id
  end
end
