module BrighterPlanet
  module BusTrip
    module Characterization
      def self.included(base)
        base.characterize do
          has :bus_class
          has :duration # measures time in minutes
          has :distance_estimate, :trumps => :duration, :measures => :length
        end
      end
    end
  end
end
