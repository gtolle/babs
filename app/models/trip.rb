class Trip < ActiveRecord::Base
  belongs_to :start_station, :class_name => Station
  belongs_to :end_station, :class_name => Station
  belongs_to :route
  belongs_to :customer_zip_code, :class_name => ZipCode

  def save_directions
    route = start_station.save_directions_to(end_station)
    self.route = route
    self.save
  end

  def route_polyline

    if self.route
      return self.route.overview_polyline
    else
      route = Route.where(:origin_station => self.start_station, :destination_station => self.end_station).first
      if route
        self.route = route
        self.save
        return route.overview_polyline
      end
    end

    return nil
  end
  
  def zip_code_obj
    if self.customer_zip_code
      self.customer_zip_code
    elsif self.zip_code.present?
      zco = ZipCode.where(:code => self.zip_code).first
      if zco
        self.customer_zip_code = zco
        self.save
        return zco
      else
        zco = ZipCode.create(:code => self.zip_code)
        self.customer_zip_code = zco
        self.save
        return zco
      end
    end
    return nil
  end
end
