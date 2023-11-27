class AddNameToBulkEmails < ActiveRecord::Migration[7.0]
  def change
    add_column :bulk_emails, :name, :string
  end
end
