class AddRouteToTrips < ActiveRecord::Migration
  def change
    add_reference :trips, :route, index: true
  end
end
