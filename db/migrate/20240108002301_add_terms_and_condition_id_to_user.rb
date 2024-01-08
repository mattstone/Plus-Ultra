class AddTermsAndConditionIdToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :terms_and_condition_id, :integer
    
    add_index :users, :terms_and_condition_id
  end
end
