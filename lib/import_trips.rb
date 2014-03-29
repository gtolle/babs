stations_by_name = {}
Station.all.each { |station| stations_by_name[station.name] = station }

count = 0

Trip.delete_all

CSV.foreach("201402_babs_open_data/201402_trip_data.csv", :headers => true) do |row|
  # #<CSV::Row "Trip ID":"7747" "Duration":"804" "Start Date":"9/1/2013 12:26" "Start Station":"2nd at Folsom" "Start Terminal":"62" "End Date":"9/1/2013 12:40" "End Station":"Harry Bridges Plaza (Ferry Building)" "End Terminal":"50" "Bike #":"356" "Subscription Type":"Customer" "Zip Code":"94158">

  trip = Trip.create(:babs_id => row['Trip ID'], 
                     :duration => row['Duration'],
                     :start_time => DateTime.strptime(row['Start Date'], '%m/%d/%Y %H:%M'),
                     :start_station_name => row["Start Station"],
                     :start_station => stations_by_name[row["Start Station"]],
                     :start_terminal => row["Start Terminal"],
                     :end_time => DateTime.strptime(row['End Date'], '%m/%d/%Y %H:%M'),
                     :end_station_name => row["End Station"],
                     :end_station => stations_by_name[row["End Station"]],
                     :end_terminal => row["End Terminal"],
                     :bike_number => row["Bike #"],
                     :subscription_type => row["Subscription Type"],
                     :zip_code => row["Zip Code"])
  count += 1
  puts count if count % 1000 == 0
end
