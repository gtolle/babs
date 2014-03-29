json.trips do
  json.array!(@trips) do |trip|
    json.start_pos [ trip.start_station.lat, trip.start_station.lng ]
    json.end_pos [ trip.end_station.lat, trip.end_station.lng ]
  end
  # json.array!(@trips)
end
