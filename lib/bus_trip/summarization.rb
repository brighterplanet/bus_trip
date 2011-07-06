module BrighterPlanet
  module BusTrip
    module Summarization
      def self.included(base)
        base.summarize do |has|
          has.adjective lambda { |bus_trip| "#{bus_trip.distance_estimate.convert(:kilometres, :miles).round(1)}-mile" }, :if => :distance_estimate
          has.adjective lambda { |bus_trip| "#{bus_trip.duration.convert(:seconds, :minutes).round(1)}-minute" }, :if => :duration
          has.identity 'bus trip'
          has.verb :take
          has.aspect :perfect
        end
      end
    end
  end
end
