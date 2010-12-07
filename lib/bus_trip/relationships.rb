module BrighterPlanet
  module BusTrip
    module Relationships
      def self.included(target)
        target.belongs_to :bus_class
      end
    end
  end
end
