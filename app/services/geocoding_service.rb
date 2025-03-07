require 'sypex_geo'

module GeocodingService
  def self.call(ip:)
    result =  if File.exist?("#{ Rails.root }/db/geocoding/SxGeoCity.dat")
                out = {}

                db = SypexGeo::Database.new("#{ Rails.root }/db/geocoding/SxGeoCity.dat")

                location = db&.query(ip)

                out[:city] = location&.city

                out[:region] = location&.region

                out[:country_code] = location&.country_code

                out[:country] = location&.country

                out
              else
                false
              end
    result
  end
end
