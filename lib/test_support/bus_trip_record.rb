require 'bus_trip'

class BusTripRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::BusTrip
  belongs_to :bus_class

  conversion_accessor :distance_estimate, :external => :miles, :internal => :kilometres
    
  falls_back_on
  
  def emission_date
    created_at.to_date #FIXME we should add a date characteristic for this emitter
  end
end

