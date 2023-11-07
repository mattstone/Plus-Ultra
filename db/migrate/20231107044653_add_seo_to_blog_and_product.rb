class AddSeoToBlogAndProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :blogs, :meta_description, :string
    add_column :blogs, :meta_keywords,    :string
    add_column :products, :meta_description, :string
    add_column :products, :meta_keywords,    :string
  end
end
