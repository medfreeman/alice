class CreateAteliers < ActiveRecord::Migration
  def change
    create_table :ateliers do |t|

      t.timestamps
    end
  end
end
