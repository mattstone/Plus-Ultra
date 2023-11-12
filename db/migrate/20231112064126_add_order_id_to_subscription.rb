class AddOrderIdToSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :order_id, :integer
  end
end
