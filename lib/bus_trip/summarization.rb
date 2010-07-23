require 'summary_judgement'

module BrighterPlanet
  module BusTrip
    module Summarization
      def self.included(base)
        base.extend SummaryJudgement
        base.summarize do |has|
          has.adjective lambda { |bus_trip| "#{bus_trip.distance_estimate_in_miles.adaptive_round(1)}-mile" }, :if => :distance_estimate
          has.adjective lambda { |bus_trip| "#{bus_trip.duration}-minute" }, :if => :duration
          has.identity 'bus trip'
          has.verb :take
          has.aspect :perfect
        end
      end
    end
  end
end
