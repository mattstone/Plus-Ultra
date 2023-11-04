class AddDateClearedFundstoTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :date_cleared_funds, :datetime
  end
end
