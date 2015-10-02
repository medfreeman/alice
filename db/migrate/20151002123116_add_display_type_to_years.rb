class AddDisplayTypeToYears < ActiveRecord::Migration
  def change
    add_column :years, :display_by_users, :boolean, default: false
  end
end
