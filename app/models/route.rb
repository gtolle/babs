class Route < ActiveRecord::Base
  belongs_to :origin_station, :class_name => Station
  belongs_to :destination_station, :class_name => Station
  has_many :legs
  has_many :steps

  def self.create_for_stations( json, origin, destination )
    route = Route.find_or_create_by(
                                    :origin_station => origin, 
                                    :destination_station => destination,
                                    :summary => json['summary'], 
                                    :overview_polyline => json['overview_polyline']['points'],
                                    :bounds_ne_lat => json['bounds']['northeast']['lat'],
                                    :bounds_ne_lng => json['bounds']['northeast']['lng'],
                                    :bounds_sw_lat => json['bounds']['southwest']['lat'],
                                    :bounds_sw_lng => json['bounds']['southwest']['lng']
                                    )
    json['legs'].each_with_index do |leg_json, index|
      leg = route.legs.find_or_create_by( 
                                         :distance_text => leg_json['distance']['text'],
                                         :distance => leg_json['distance']['value'],
                                         :duration_text => leg_json['duration']['text'],
                                         :duration => leg_json['duration']['value'],
                                         :start_lat => leg_json['start_location']['lat'],
                                         :start_lng => leg_json['start_location']['lng'],
                                         :start_addr => leg_json['start_address'],
                                         :end_lat => leg_json['end_location']['lat'],
                                         :end_lng => leg_json['end_location']['lng'],
                                         :end_addr => leg_json['end_address'],
                                         :idx => index
                                         )
      leg_json['steps'].each_with_index do |step_json, index|
        step = leg.steps.find_or_create_by(
                                           :route => route,
                                           :distance_text => step_json['distance']['text'],
                                           :distance => step_json['distance']['value'],
                                           :duration_text => step_json['duration']['text'],
                                           :duration => step_json['duration']['value'],
                                           :start_lat => step_json['start_location']['lat'],
                                           :start_lng => step_json['start_location']['lng'],
                                           :end_lat => step_json['end_location']['lat'],
                                           :end_lng => step_json['end_location']['lng'],
                                           :html_instructions => step_json['html_instructions'],
                                           :maneuver => step_json['maneuver'],
                                           :polyline => step_json['polyline']['points'],
                                           :travel_mode => step_json['travel_mode'],
                                           :idx => index
                                           )
      end
    end

    return route
  end    
end
