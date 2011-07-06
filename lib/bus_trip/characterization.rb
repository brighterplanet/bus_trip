module BrighterPlanet
  module BusTrip
    module Characterization
      def self.included(base)
        base.characterize do
          has :date
          has :bus_class
          has :duration, :measures => :time
          has :distance, :measures => Measurement::BigLength
        end
      end
    end
  end
end
