class AddStripeClientSecretToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :stripe_client_secret,  :string
    add_column :transactions, :stripe_payment_intent, :string
    
    add_index :transactions, :stripe_client_secret
    add_index :transactions, :stripe_payment_intent    
  end
end
