class Station < ActiveRecord::Base

  def save_directions_to( station )
    route = Route.where(:origin_station => self, :destination_station => station).first
    return route if route

    sleep(0.5)
    base_url = "https://maps.googleapis.com/maps/api/directions/json"
    params = {
      :origin => "#{self.lat},#{self.lng}",
      :destination => "#{station.lat},#{station.lng}",
      :sensor => false,
      :mode => 'bicycling',
      :key => 'AIzaSyCCdZNHbzIfHR7vlZ6ja_OBLxMhlj3dfZw'
    }
    url = base_url + "?" + params.to_query

    response = RestClient::Request.execute( :method => :get, :url => url )
    json = JSON.parse(response.body)
    if json['routes'].length > 0
      route_json = json['routes'][0]
      route = Route.create_for_stations( route_json, self, station )
      return route
    else
      return nil
    end
  end
end
