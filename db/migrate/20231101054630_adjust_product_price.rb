class AdjustProductPrice < ActiveRecord::Migration[7.0]
  def change
    rename_column :products, :price, :price_in_cents
  end
end
