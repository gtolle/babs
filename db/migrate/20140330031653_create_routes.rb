class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.references :origin_station, index: true
      t.references :destination_station, index: true
      t.string :summary
      t.text :overview_polyline
      t.float :bounds_ne_lat
      t.float :bounds_ne_lng
      t.float :bounds_sw_lat
      t.float :bounds_sw_lng

      t.timestamps
    end
  end
end
