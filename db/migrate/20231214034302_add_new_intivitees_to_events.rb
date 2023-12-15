class AddNewIntiviteesToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :new_invitees, :json, default: []
  end
end
