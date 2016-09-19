class AddArchivedToYears < ActiveRecord::Migration
  def change
    add_column :years, :archived, :boolean, default: false
  end
end
