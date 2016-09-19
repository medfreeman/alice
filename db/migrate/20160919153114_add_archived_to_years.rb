class AddArchivedToYears < ActiveRecord::Migration
  def change
    add_column :years, :archived, :boolean
  end
end
