module BrighterPlanet
  module BusTrip
    module Data
      def self.included(base)
        base.create_table do
          date   'date'
          string 'bus_class_name'
          float  'duration'
          float  'distance'
        end
      end
    end
  end
end
