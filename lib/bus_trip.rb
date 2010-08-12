require 'emitter'

module BrighterPlanet
  module BusTrip
    extend BrighterPlanet::Emitter

    def self.bus_trip_model
      if Object.const_defined? 'BusTrip'
        ::BusTrip
      elsif Object.const_defined? 'BusTripRecord'
        BusTripRecord
      else
        raise 'There is no bus_trip model'
      end
    end
  end
end
