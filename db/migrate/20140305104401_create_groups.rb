class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :visibility
      t.integer :participation

      t.timestamps
    end
  end
end
