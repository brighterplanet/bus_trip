require 'data_miner'

module BrighterPlanet
  module BusTrip
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            string   'bus_class_id'
            float    'duration'
            float    'distance_estimate'
            date     'date'
          end
          
          process :run_data_miner_on_belongs_to_associations
        end
      end
    end
  end
end
