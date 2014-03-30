class CreateLegs < ActiveRecord::Migration
  def change
    create_table :legs do |t|
      t.references :route, index: true
      t.string :distance_text
      t.integer :distance
      t.string :duration_text
      t.integer :duration
      t.float :start_lat
      t.float :start_lng
      t.string :start_addr
      t.float :end_lat
      t.float :end_lng
      t.string :end_addr
      t.integer :idx

      t.timestamps
    end
  end
end
