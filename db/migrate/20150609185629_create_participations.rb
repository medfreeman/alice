class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
    	t.references :author
    	t.references :post
      t.timestamps
    end
  end
end
