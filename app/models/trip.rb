class Trip < ActiveRecord::Base
  belongs_to :start_station, :class_name => Station
  belongs_to :end_station, :class_name => Station
end
