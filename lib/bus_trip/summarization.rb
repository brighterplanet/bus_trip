module BrighterPlanet
  module Flight
    module Summarization
      def self.included(base)
        base.summarize do |has|
    has.adjective lambda { |bus_trip| "#{bus_trip.distance_estimate_in_miles.adaptive_round(1)}-mile" }, :if => :distance_estimate
    has.adjective lambda { |bus_trip| "#{bus_trip.duration}-minute" }, :if => :duration
    has.identity 'bus trip'
    has.verb :take
    has.aspect :perfect
  end

  def emission_date
    created_at.to_date #FIXME we should add a date characteristic for this emitter
  end
  
end

      end
    end
  end
end
