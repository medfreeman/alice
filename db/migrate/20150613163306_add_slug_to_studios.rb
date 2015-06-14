class AddSlugToStudios < ActiveRecord::Migration
  def change
    add_column :studios, :slug, :string
    add_index :studios, :slug
  end
end
