class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.references :user
      t.string     :name
      t.datetime   :start_datetime 
      t.datetime   :end_datetime
      t.json       :invitees, default: []

      t.timestamps
    end
    
    add_index :events, :user_id
    add_index :events, :start_datetime
  end
end
