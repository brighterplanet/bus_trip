require 'bus_trip'

class BusTripRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::BusTrip
end
