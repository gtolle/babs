class HomeController < ApplicationController
  def stations
    @stations = Station.all
  end

  def trips
    @start_date = Time.zone.local(2014, 2, 16)
    @end_date = @start_date + 1.day
    #end_date = start_date + 12.hours
    #@trips = Trip.joins(:start_station, :end_station).includes(:start_station, :end_station).where('start_time > ? and start_time < ? and stations.landmark = ?', date, date + 1.day, "San Francisco")
    @trips = Trip.joins(:start_station, :end_station).includes(:start_station, :end_station, :customer_zip_code).where('start_time > ? and start_time < ?', @start_date, @end_date)
    # @trips.each { |trip| trip.save_directions }
  end

end
