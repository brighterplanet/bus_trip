require 'bus_trip'

class BusTripRecord < ActiveRecord::Base
  include BrighterPlanet::Emitter
  include BrighterPlanet::BusTrip
end
