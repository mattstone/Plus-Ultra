class AddStripePaymentMethodToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :stripe_payment_method, :string
  end
end
