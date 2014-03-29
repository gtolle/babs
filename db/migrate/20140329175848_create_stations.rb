class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.integer :babs_id
      t.index :babs_id, :unique => true
      t.string :name
      t.float :lat
      t.float :lng
      t.integer :dockcount
      t.string :landmark
      t.date :installation

      t.timestamps
    end
  end
end
