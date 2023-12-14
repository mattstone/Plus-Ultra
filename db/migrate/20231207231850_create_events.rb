class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.references :user
      t.integer    :type
      t.string     :name
      t.string     :location
      t.string     :video_url
      t.datetime   :start_datetime 
      t.datetime   :end_datetime
      t.json       :invitees, default: []

      t.timestamps
    end
    
    add_index :events, :type
    add_index :events, :start_datetime
  end
end
