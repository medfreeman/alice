class AddSuperDIrectorToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :super_director, :boolean, default: false
  end
end
