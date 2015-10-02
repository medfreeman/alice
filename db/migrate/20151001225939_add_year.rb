class AddYear < ActiveRecord::Migration
  def change
  	create_table :years do |t|
  		t.string :name
  		t.string :slug
  		t.timestamps
  	end

  	add_reference :studios, :year
  	add_reference :users, :year
  	add_reference :posts, :year
  end
end
