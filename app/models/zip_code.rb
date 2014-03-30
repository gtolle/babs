class ZipCode < ActiveRecord::Base
  before_create :cleanup_code
  before_create :geocode

  def cleanup_code
    if self.code.length == 4
      self.code = "0#{self.code}"
    end
  end

  def geocode
    sleep(0.25)
    base_url = "https://maps.googleapis.com/maps/api/geocode/json"
    params = {
      :address => self.code,
      :sensor => false,
      :key => 'AIzaSyCCdZNHbzIfHR7vlZ6ja_OBLxMhlj3dfZw'
    }
    url = base_url + "?" + params.to_query
    
    response = RestClient::Request.execute( :method => :get, :url => url )
    json = JSON.parse(response.body)
    if json['results'] and json['results'].length > 0
      self.lat = json['results'][0]['geometry']['location']['lat']
      self.lng = json['results'][0]['geometry']['location']['lng']
    end
  end
end
