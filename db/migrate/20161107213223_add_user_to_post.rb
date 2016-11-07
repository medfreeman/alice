class AddUserToPost < ActiveRecord::Migration
  def change
    add_reference :posts, :owner
  end
end
