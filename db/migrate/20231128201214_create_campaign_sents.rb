class CreateCampaignSents < ActiveRecord::Migration[7.0]
  def change
    create_table :communication_sents do |t|
      t.references :communication 
      t.references :user 
      t.references :subscriber
      
      t.integer    :opens,  default: 0
      t.integer    :clicks, default: 0
      
      t.json       :history, default: []

      t.timestamps
    end
    
  end
end
