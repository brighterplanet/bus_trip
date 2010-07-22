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
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
  
  conversion_accessor :distance_estimate, :external => :miles, :internal => :kilometres
    
  falls_back_on
  
  characterize do
    has :bus_class
    has :duration # measures time in minutes
    has :distance_estimate, :trumps => :duration, :measures => :length
  end
  add_implicit_characteristics
  
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
  
  summarize do |has|
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
