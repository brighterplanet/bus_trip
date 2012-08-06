require 'earth/bus/bus_class'

module BrighterPlanet
  module BusTrip
    module Relationships
      def self.included(target)
        target.belongs_to :bus_class, :foreign_key => 'bus_class_name'
      end
    end
  end
end
