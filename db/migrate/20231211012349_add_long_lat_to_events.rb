class AddLongLatToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :latitude,  :decimal
    add_column :events, :longitude, :decimal
  end
end
