class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :babs_id
      t.index :babs_id, :unique => true
      t.integer :duration
      t.datetime :start_time
      t.string :start_station_name
      t.references :start_station, index: true
      t.integer :start_terminal
      t.datetime :end_time
      t.string :end_station_name
      t.references :end_station, index: true
      t.integer :end_terminal
      t.integer :bike_number
      t.string :subscription_type
      t.string :zip_code

      t.timestamps
    end
  end
end
