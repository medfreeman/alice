class AddSuperStudentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :super_student, :boolean, default: false
  end
end
