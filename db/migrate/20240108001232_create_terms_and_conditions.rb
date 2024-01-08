class CreateTermsAndConditions < ActiveRecord::Migration[7.1]
  def change
    create_table :terms_and_conditions do |t|
      t.integer :status, default: 0
      t.timestamps
    end
    
  end
end
