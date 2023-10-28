class CreateMailingLists < ActiveRecord::Migration[7.0]
  def change
    create_table :mailing_lists do |t|
      t.string :name 

      t.timestamps
    end
    
    ml = MailingList.new 
    ml.name = "Newsletter"
    ml.save
  end
end
