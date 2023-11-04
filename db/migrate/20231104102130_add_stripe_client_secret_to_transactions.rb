class AddStripeClientSecretToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :stripe_client_secret, :string
  end
end
