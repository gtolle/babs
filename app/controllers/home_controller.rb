class HomeController < ApplicationController
  def stations
    @stations = Station.all
  end

  def trips
    @start_date = Time.strptime(params[:date], "%m/%d/%Y").in_time_zone(Time.zone) - 3.hours
    @end_date = @start_date + 1.day

    @trips = Trip.joins(:start_station, :end_station).includes(:start_station, :end_station).where('start_time > ? and start_time < ?', @start_date, @end_date)

    render :json => {
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
    }
    #end_date = start_date + 12.hours
    #@trips = Trip.joins(:start_station, :end_station).includes(:start_station, :end_station).where('start_time > ? and start_time < ? and stations.landmark = ?', date, date + 1.day, "San Francisco")
    # @trips = Trip.joins(:start_station, :end_station).includes(:start_station, :end_station, :customer_zip_code).where('start_time > ? and start_time < ? and start_station_id not in (50, 53, 58,59) and end_station_id not in (50, 53, 58,59)', @start_date, @end_date)
    # @trips.each { |trip| trip.save_directions }
  end

end
