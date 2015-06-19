class AddStudioIdToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :studio_id, :integer, index: true
  end
end
