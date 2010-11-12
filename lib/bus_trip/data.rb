module BrighterPlanet
  module BusTrip
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            string   'bus_class_name'
            float    'duration'
            float    'distance'
          end
          
          process :run_data_miner_on_belongs_to_associations
        end
      end
    end
  end
end
