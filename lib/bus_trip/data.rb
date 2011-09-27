module BrighterPlanet
  module BusTrip
    module Data
      def self.included(base)
        base.col :date, :type => :date
        base.col :bus_class_name
        base.col :duration, :type => :float
        base.col :distance, :type => :float
      end
    end
  end
end