class AddOneTimeCodeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :one_time_code, :integer
    
    add_index :users, :one_time_code
  end
end
