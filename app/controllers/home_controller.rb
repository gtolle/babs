class HomeController < ApplicationController
  def stations
    @stations = Station.all
  end

  def trips
    date_parts = params[:date].split("/")
    normal_date = "#{date_parts[1]}-#{date_parts[0]}-#{date_parts[2]}"
    @start_date = Time.zone.parse(normal_date) + 5.hours
    @end_date = @start_date + 1.day

    json = Rails.cache.fetch("trips/#{@start_date}") do
      @trips = Trip.joins(:start_station, :end_station).includes(:start_station, :end_station).where('start_time > ? and start_time < ?', @start_date, @end_date)

      {
        :start_tick => @start_date.to_i,
        :end_tick => @end_date.to_i,
        :trips => @trips.map { |trip| 
          {
            :id => trip.babs_id,
            :start_tick => trip.start_time.to_i,
            :end_tick => trip.end_time.to_i,
            :start_station_id => trip.start_station.id,
            :end_station_id => trip.end_station.id,
            :start_pos => [ trip.start_station.lat, trip.start_station.lng ],
            :end_pos => [ trip.end_station.lat, trip.end_station.lng ],
            :duration => trip.duration
          }
        }
      }.to_json
    end

    render :json => json
  end
end
