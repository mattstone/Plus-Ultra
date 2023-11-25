class CreateCommunications < ActiveRecord::Migration[7.0]
  def change
    create_table :communications do |t|
      t.references :campaign
      t.integer    :communication_type, default: 0
      t.integer    :layout,             default: 0
      t.integer    :lifecycle,          default: 0
      t.string     :name 
      t.string     :subject
      t.timestamps
    end
  end
end
