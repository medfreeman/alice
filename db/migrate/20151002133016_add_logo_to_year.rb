class AddLogoToYear < ActiveRecord::Migration
  def up
  	add_attachment :years, :logo
  end

  def down
		remove_attachment :years, :logo
  end
end
