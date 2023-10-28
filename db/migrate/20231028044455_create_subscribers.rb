class CreateSubscribers < ActiveRecord::Migration[7.0]
  def change
    create_table :subscribers do |t|
      t.references :mailing_list 
      t.string :email 
      t.string :first_name
      t.string :last_name 
      t.string :mobile_number
      t.string :mobile_number_country_code
      t.timestamps
    end
  end
end
