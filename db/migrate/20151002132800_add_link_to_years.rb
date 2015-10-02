class AddLinkToYears < ActiveRecord::Migration
  def change
    add_column :years, :link, :string
  end
end
