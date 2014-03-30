json.start_tick @start_date.to_i
json.end_tick @end_date.to_i
json.trips do
  json.array!(@trips) do |trip|
    json.id trip.babs_id
    json.start trip.start_station_name
    json.end trip.end_station_name
    json.start_time trip.start_time
    json.start_tick trip.start_time.to_i
    json.end_tick trip.end_time.to_i
    json.start_pos [ trip.start_station.lat, trip.start_station.lng ]
    json.end_pos [ trip.end_station.lat, trip.end_station.lng ]
    json.duration trip.duration
    # if trip.customer_zip_code and trip.subscription_type == "Subscriber"
    #   json.zip_code do 
    #     json.code trip.customer_zip_code.code
    #     json.lat trip.customer_zip_code.lat
    #     json.lng trip.customer_zip_code.lng
    #   end
    # end
    json.zip_code trip.zip_code
    # json.overview_polyline trip.route_polyline
  end
end
