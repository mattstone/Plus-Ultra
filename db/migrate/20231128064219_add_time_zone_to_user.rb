class AddTimeZoneToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :time_zone, :string, default: "(GMT+10:00) Australia/Sydney"
  end
end
