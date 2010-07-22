module BrighterPlanet
  module BusTrip
    extend self

    def included(base)
      require 'bus_trip/carbon_model'
      require 'bus_trip/characterization'
      require 'bus_trip/data'
      require 'bus_trip/summarization'

      base.send :include, BrighterPlanet::BusTrip::CarbonModel
      base.send :include, BrighterPlanet::BusTrip::Characterization
      base.send :include, BrighterPlanet::BusTrip::Data
      base.send :include, BrighterPlanet::BusTrip::Summarization
    end
    def bus_trip_model
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
