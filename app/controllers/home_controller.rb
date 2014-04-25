class HomeController < ApplicationController
  def stations
    @stations = Station.all
  end

  def trips
    @start_date = Time.strptime(params[:date], "%m/%d/%Y").in_time_zone(Time.zone) - 3.hours
    @end_date = @start_date + 1.day

    @trips = Trip.joins(:start_station, :end_station).includes(:start_station, :end_station).where('start_time > ? and start_time < ?', @start_date, @end_date)

    #end_date = start_date + 12.hours
    #@trips = Trip.joins(:start_station, :end_station).includes(:start_station, :end_station).where('start_time > ? and start_time < ? and stations.landmark = ?', date, date + 1.day, "San Francisco")
    # @trips = Trip.joins(:start_station, :end_station).includes(:start_station, :end_station, :customer_zip_code).where('start_time > ? and start_time < ? and start_station_id not in (50, 53, 58,59) and end_station_id not in (50, 53, 58,59)', @start_date, @end_date)
    # @trips.each { |trip| trip.save_directions }
  end

end
