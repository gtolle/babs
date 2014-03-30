class AddZipCodeToTrips < ActiveRecord::Migration
  def change
    add_reference :trips, :customer_zip_code, index: true
  end
end
