require 'bus_trip'

class BusTripRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::BusTrip
  belongs_to :bus_class

  conversion_accessor :distance_estimate, :external => :miles, :internal => :kilometres
    
  falls_back_on
  
  class << self
    def research(key)
      case key
      when :diesel_emission_factor
        22.450.pounds_per_gallon.to(:kilograms_per_litre) # CO2 / diesel  https://brighterplanet.sifterapp.com/projects/30/issues/454
      when :gasoline_emission_factor
        23.681.pounds_per_gallon.to(:kilograms_per_litre) # CO2 / gasoline  https://brighterplanet.sifterapp.com/projects/30/issues/454
      when :alternative_fuels_emission_factor
        9.742.pounds_per_gallon.to(:kilograms_per_litre) # CO2 / equiv alternative fuels  https://brighterplanet.sifterapp.com/projects/30/issues/454
      end
    end
  end
  
  def emission_date
    created_at.to_date #FIXME we should add a date characteristic for this emitter
  end
end
