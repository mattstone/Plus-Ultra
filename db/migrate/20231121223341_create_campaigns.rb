class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change

    create_table :campaigns do |t|
      t.references :channel 
      t.string     :name
      t.string     :tag
      t.timestamps
    end
    
  end
end
