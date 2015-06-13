class AddStudioToUsers < ActiveRecord::Migration
  def change
    add_column :users, :studio_id, :string
    add_index :users, :studio_id
  end
end
