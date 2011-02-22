module BrighterPlanet
  module BusTrip
    module Characterization
      def self.included(base)
        base.characterize do
          has :date
          has :bus_class
          has :duration
          has :distance, :measures => :length
        end
      end
    end
  end
end
