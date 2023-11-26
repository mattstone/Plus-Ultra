class CreateBulkEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :bulk_emails do |t|
      t.references :mailing_list
      t.references :communication
      
      t.integer    :sent,  default: 0
      t.integer    :opens, default: 0
      
      t.datetime   :datetime_sent

      t.timestamps
    end
  end
end
