class AddIndexesToTrips < ActiveRecord::Migration
  def change
    add_index :trips, :start_time
    add_index :trips, :end_time
    add_index :stations, :landmark
  end
end
