class AddDefaultToYears < ActiveRecord::Migration
  def change
    add_column :years, :default, :boolean, default: false
  end
end
