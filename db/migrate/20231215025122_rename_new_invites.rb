class RenameNewInvites < ActiveRecord::Migration[7.1]
  def change
    remove_column :events, :invitees
    
    rename_column :events, :new_invitees, :invitees
  end
end
