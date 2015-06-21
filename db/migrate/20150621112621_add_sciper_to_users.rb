class AddSciperToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sciper, :integer
  end
end
