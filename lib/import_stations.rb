CSV.foreach("201402_babs_open_data/201402_station_data.csv", :headers => true) do |row|
  Station.find_or_create_by(:babs_id => row['station_id'], :name => row['name'], :lat => row['lat'], :lng => row['long'], :dockcount => row['dockcount'], :landmark => row['landmark'], :installation => Date.strptime(row['installation'], '%m/%d/%Y') )
end
