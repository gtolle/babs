class HomeController < ApplicationController
  def stations
    @stations = Station.where(:landmark => 'San Francisco')
  end

  def trips
    date = Time.zone.local(2014, 2, 16)
    @trips = Trip.joins(:start_station, :end_station).includes(:start_station, :end_station).where('start_time > ? and start_time < ? and stations.landmark = ?', date, date + 1.day, "San Francisco")
  end

end
