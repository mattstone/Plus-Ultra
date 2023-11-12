class AddPaymentMethodToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :stripe_payment_method, :string
  end
end
