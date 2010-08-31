require 'characterizable'

module BrighterPlanet
  module BusTrip
    module Characterization
      def self.included(base)
        base.send :include, Characterizable
        base.characterize do
          has :bus_class
          has :duration # measures time in minutes
          has :distance_estimate, :trumps => :duration, :measures => :length
        end
        base.add_implicit_characteristics
      end
    end
  end
end
