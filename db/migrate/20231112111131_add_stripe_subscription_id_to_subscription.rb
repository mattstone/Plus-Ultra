class AddStripeSubscriptionIdToSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :stripe_subscription_id, :string 
    
    add_index :subscriptions, :stripe_subscription_id
  end
end
