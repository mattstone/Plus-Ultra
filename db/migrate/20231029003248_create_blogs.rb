class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.references :user 
      t.integer    :status, default: 0
      t.string     :title
      t.string     :slug
      t.datetime   :datetime_to_publish
      t.timestamps
    end
  end
end
