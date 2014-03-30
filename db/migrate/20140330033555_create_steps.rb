class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.references :route, index: true
      t.references :leg, index: true
      t.string :distance_text
      t.integer :distance
      t.string :duration_text
      t.integer :duration
      t.float :start_lat
      t.float :start_lng
      t.float :end_lat
      t.float :end_lng
      t.text :html_instructions
      t.text :polyline
      t.string :maneuver
      t.string :travel_mode
      t.integer :idx

      t.timestamps
    end
  end
end
