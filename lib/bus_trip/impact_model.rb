# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

require 'earth/bus/bus_class'
require 'earth/bus/bus_fuel'

### Bus trip impact model
# This model is used by the [Brighter Planet](http://brighterplanet.com) [CM1 web service](http://impact.brighterplanet.com) to calculate the per-passenger impacts of a bus trip, such as energy use and greenhouse gas emissions.

##### Timeframe
# The model calculates impacts that occured during a particular time period (`timeframe`).
# For example if the `timeframe` is February 2010, a trip that occurred (`date`) on February 15, 2010 will have impacts, but a trip that occurred on January 31, 2010 will have zero impacts.
#
# The default `timeframe` is the current calendar year.

##### Calculations
# The final impacts are the result of the calculations below. These are performed in reverse order, starting with the last calculation listed and finishing with the greenhouse gas emissions calculation.
#
# Each calculation listing shows:
#
# * value returned (*units of measurement*)
# * description of the value
# * calculation methods, listed from most to least preferred
#
# Some methods use `values` returned by prior calculations. If any of these `values` are unknown the method is skipped.
# If all the methods for a calculation are skipped, the value the calculation would return is unknown.

##### Standard compliance
# When compliance with a particular standard is requested, all methods that do not comply with that standard are ignored.
# Thus any `values` a method needs will have been calculated using a compliant method or will be unknown.
# To see which standards a method complies with, look at the `:complies =>` section of the code in the right column.
#
# Client input complies with all standards.

##### Collaboration
# Contributions to this impact model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](https://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
module BrighterPlanet
  module BusTrip
    module ImpactModel
      def self.included(base)
        base.decide :impact, :with => :characteristics do
          # * * *
          
          #### Carbon (*kg CO<sub>2</sub>e*)
          # *One passenger's share of the trip's anthropogenic greenhouse gas emissions during `timeframe`.*
          committee :carbon do
            # Sum `co2 emission` (*kg*), `ch4 emission` (*kg CO<sub>2</sub>e*), `n2o emission` (*kg CO<sub>2</sub>e*), and `hfc emission` (*kg CO<sub>2</sub>e*) to give *kg CO<sub>2</sub>e*.
            quorum 'from co2 emission, ch4 emission, n2o emission, and hfc emission', :needs => [:co2_emission, :ch4_emission, :n2o_emission, :hfc_emission],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
              characteristics[:co2_emission] + characteristics[:ch4_emission] + characteristics[:n2o_emission] + characteristics[:hfc_emission]
            end
          end
          
          #### CO<sub>2</sub> emission (*kg*)
          # *One passenger's share of the trip's CO<sub>2</sub> emissions from anthropogenic sources during `timeframe`.*
          committee :co2_emission do
            # Multiply each `fuel use` (*l*) by the [fuel](http://data.brighterplanet.com/bus_fuels)'s co2 emission factor (*kg / l*) to give co2 emissions from each fuel (*kg*).
            # Sum the fuel co2 emissions to give *kg*.
            quorum 'from fuel uses', :needs => :fuel_uses,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:fuel_uses][:gasoline]  * BusFuel.find_by_name("Gasoline").co2_emission_factor +
                characteristics[:fuel_uses][:diesel]    * BusFuel.find_by_name("Diesel").co2_emission_factor +
                characteristics[:fuel_uses][:cng]       * BusFuel.find_by_name("CNG").co2_emission_factor +
                characteristics[:fuel_uses][:lng]       * BusFuel.find_by_name("LNG").co2_emission_factor +
                characteristics[:fuel_uses][:lpg]       * BusFuel.find_by_name("LPG").co2_emission_factor +
                characteristics[:fuel_uses][:methanol]  * BusFuel.find_by_name("Methanol").co2_emission_factor +
                characteristics[:fuel_uses][:biodiesel] * BusFuel.find_by_name("Biodiesel").co2_emission_factor
            end
          end
          
          ### CO<sub>2</sub> biogenic emission (*kg*)
          # One passenger's share of the trip's CO<sub>2</sub> emissions from biogenic sources during `timeframe`.
          committee :co2_biogenic_emission do
            # Multiply each `fuel use` (*l*) by the [fuel](http://data.brighterplanet.com/bus_fuels)'s co2 biogenic emission factor (*kg / l*) to give co2 biogenic emissions from each fuel (*kg*).
            # Sum the fuel co2 biogenic emissions to give *kg*.
            quorum 'from fuel uses', :needs => :fuel_uses,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:fuel_uses][:gasoline]  * BusFuel.find_by_name("Gasoline").co2_biogenic_emission_factor +
                characteristics[:fuel_uses][:diesel]    * BusFuel.find_by_name("Diesel").co2_biogenic_emission_factor +
                characteristics[:fuel_uses][:cng]       * BusFuel.find_by_name("CNG").co2_biogenic_emission_factor +
                characteristics[:fuel_uses][:lng]       * BusFuel.find_by_name("LNG").co2_biogenic_emission_factor +
                characteristics[:fuel_uses][:lpg]       * BusFuel.find_by_name("LPG").co2_biogenic_emission_factor +
                characteristics[:fuel_uses][:methanol]  * BusFuel.find_by_name("Methanol").co2_biogenic_emission_factor +
                characteristics[:fuel_uses][:biodiesel] * BusFuel.find_by_name("Biodiesel").co2_biogenic_emission_factor
            end
          end
          
          #### CH<sub>4</sub> emission (*kg CO<sub>2</sub>e*)
          # *One passenger's share of the trip's CH<sub>4</sub> emissions during `timeframe`.*
          committee :ch4_emission do
            # Sum the `fuel uses` (*l*) to give total fuel use (*l*).
            # Divide each `fuel use` (*l*) by total fuel use (*l*) and multiply by `distance per passenger` (*km*) to give the distance attributed to each fuel (*km*).
            # Multiply the distance attributed to each fuel (*km*) by the [fuel](http://data.brighterplanet.com/bus_fuels)'s ch4 emission factor (*kg CO<sub>2</sub>e / km*) to give ch4 emissions from each fuel (*kg CO<sub>2</sub>e*).
            # Sum the fuel ch4 emissions to give *kg CO<sub>2</sub>e*.
            quorum 'from distance per passenger and fuel uses', :needs => [:distance_per_passenger, :fuel_uses],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                total_fuel = characteristics[:fuel_uses].values.inject(:+)
                
                if total_fuel > 0
                  characteristics[:fuel_uses][:gasoline]  / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("Gasoline").ch4_emission_factor +
                  characteristics[:fuel_uses][:diesel]    / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("Diesel").ch4_emission_factor +
                  characteristics[:fuel_uses][:cng]       / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("CNG").ch4_emission_factor +
                  characteristics[:fuel_uses][:lng]       / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("LNG").ch4_emission_factor +
                  characteristics[:fuel_uses][:lpg]       / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("LPG").ch4_emission_factor +
                  characteristics[:fuel_uses][:methanol]  / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("Methanol").ch4_emission_factor +
                  characteristics[:fuel_uses][:biodiesel] / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("Biodiesel").ch4_emission_factor
                else
                  0
                end
            end
          end
          
          #### N<sub>2</sub>O emission (*kg CO<sub>2</sub>e*)
          # *One passenger's share of the trip's N<sub>2</sub>O emissions during `timeframe`.*
          committee :n2o_emission do
            # Sum the `fuel uses` (*l*) to give total fuel use (*l*).
            # Divide each `fuel use` (*l*) by total fuel use (*l*) and multiply by `distance per passenger` (*km*) to give the distance attributed to each fuel (*km*).
            # Multiply the distance attributed to each fuel (*km*) by the [fuel](http://data.brighterplanet.com/bus_fuels)'s n2o emission factor (*kg CO<sub>2</sub>e / km*) to give n2o emissions from each fuel (*kg CO<sub>2</sub>e*).
            # Sum the fuel n2o emissions to give *kg CO<sub>2</sub>e*.
            quorum 'from distance per passenger and fuel uses', :needs => [:distance_per_passenger, :fuel_uses],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                total_fuel = characteristics[:fuel_uses].values.inject(:+)
                
                if total_fuel > 0
                  characteristics[:fuel_uses][:gasoline]  / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("Gasoline").n2o_emission_factor +
                  characteristics[:fuel_uses][:diesel]    / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("Diesel").n2o_emission_factor +
                  characteristics[:fuel_uses][:cng]       / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("CNG").n2o_emission_factor +
                  characteristics[:fuel_uses][:lng]       / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("LNG").n2o_emission_factor +
                  characteristics[:fuel_uses][:lpg]       / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("LPG").n2o_emission_factor +
                  characteristics[:fuel_uses][:methanol]  / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("Methanol").n2o_emission_factor +
                  characteristics[:fuel_uses][:biodiesel] / total_fuel * characteristics[:distance_per_passenger] * BusFuel.find_by_name("Biodiesel").n2o_emission_factor
                else
                  0
                end
            end
          end
          
          #### HFC emission (*kg CO<sub>2</sub>e*)
          # *One passenger's share of the trip's HFC emissions during `timeframe`.*
          committee :hfc_emission do
            # Multiply `distance per passenger` (*km*) by the `bus class` air conditioning emission factor (*kg CO<sub>2</sub>e / km*) to give *kg CO<sub>2</sub>e*.
            quorum 'from distance per passenger and bus class', :needs => [:distance_per_passenger, :bus_class],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:distance_per_passenger] * characteristics[:bus_class].air_conditioning_emission_factor
            end
          end
          
=begin
          #### Energy (*MJ*)
          # *One passenger's share of the trip's energy use during `timeframe`.*
          committee :energy do
            # Multiply each `fuel use` (*l*) by the [fuel](http://data.brighterplanet.com/bus_fuels)'s energy content (*MJ / l*) to give energy for each fuel (*MJ*).
            # Sum the fuel energies to give *MJ*.
            quorum 'from fuel uses', :needs => :fuel_uses do |characteristics|
              characteristics[:fuel_uses][:gasoline]  * BusFuel.find_by_name("Gasoline").energy_content +
              characteristics[:fuel_uses][:diesel]    * BusFuel.find_by_name("Diesel").energy_content +
              characteristics[:fuel_uses][:cng]       * BusFuel.find_by_name("CNG").energy_content +
              characteristics[:fuel_uses][:lng]       * BusFuel.find_by_name("LNG").energy_content +
              characteristics[:fuel_uses][:lpg]       * BusFuel.find_by_name("LPG").energy_content +
              characteristics[:fuel_uses][:methanol]  * BusFuel.find_by_name("Methanol").energy_content +
              characteristics[:fuel_uses][:biodiesel] * BusFuel.find_by_name("Biodiesel").energy_content
            end
          end
=end

=begin
  NOTE: electricity use is negligible (contributes about 0.001% of total emissions)
=end
          
          #### Fuel uses (*l*)
          # *One passenger's share of the trip's use of each of a variety of [bus fuels](http://data.brighterplanet.com/bus_fuels) during `timeframe`.*
          committee :fuel_uses do
            # For each fuel, multiply `distance per passenger` (*km*) by the `bus class` fuel intensity for the fuel (*l / km*) to give *l*.
            quorum 'from distance per passenger and bus class', :needs => [:distance_per_passenger, :bus_class],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                {
                  :gasoline  => (characteristics[:distance_per_passenger] * characteristics[:bus_class].gasoline_intensity),
                  :diesel    => (characteristics[:distance_per_passenger] * characteristics[:bus_class].diesel_intensity),
                  :cng       => (characteristics[:distance_per_passenger] * characteristics[:bus_class].cng_intensity),
                  :lng       => (characteristics[:distance_per_passenger] * characteristics[:bus_class].lng_intensity),
                  :lpg       => (characteristics[:distance_per_passenger] * characteristics[:bus_class].lpg_intensity),
                  :methanol  => (characteristics[:distance_per_passenger] * characteristics[:bus_class].methanol_intensity),
                  :biodiesel => (characteristics[:distance_per_passenger] * characteristics[:bus_class].biodiesel_intensity)
                }
            end
          end
          
          #### Distance per passenger (*km*)
          # *The distance traveled per passenger during `timeframe`.*
          committee :distance_per_passenger do
            # If `date` falls within `timeframe`, divide `distance` (*km*) by `passengers` to give *km*.
            # Otherwise distance per passenger is zero.
            quorum 'from distance, passengers, date, and timeframe', :needs => [:distance, :passengers, :date],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
=begin
  FIXME TODO date should already be coerced
=end
                date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
                timeframe.include?(date) ? characteristics[:distance] / characteristics[:passengers] : 0
            end
          end
          
          #### Distance (*km*)
          # *The trip's distance.*
          committee :distance do
            # Use client input, if available.
            
            # Otherwise divide `duration` (*seconds*) by 3600 (*seconds / hour*) and multiply by `speed` (*km / hour*) to give *km*.
            quorum 'from duration and speed', :needs => [:duration, :speed],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:duration] / 3600.0 * characteristics[:speed]
            end
            
            # Otherwise use the `bus class` average trip distance (*km*).
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              characteristics[:bus_class].distance
            end
          end
          
          #### Speed (*km / hour*)
          # *The trip's average speed.*
          committee :speed do
            # Use the [bus class](http://data.brighterplanet.com/bus_classes) average speed (*km / hour*).
            quorum 'from bus class', :needs => :bus_class,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:bus_class].speed
            end
          end
          
          #### Duration (*seconds*)
          # *The trip's duration.*
          #
          # Use client input, if available.
          
          #### Passengers
          # *The number of passengers on the bus.*
          committee :passengers do
            # Use the [bus class](http://data.brighterplanet.com/bus_classes) average number of passengers.
            quorum 'from bus class', :needs => :bus_class,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:bus_class].passengers
            end
          end
          
          #### Bus class
          # *The type of bus used.*
          committee :bus_class do
            # Use client input, if available.
            
            # Otherwise use an artificial [bus class](http://data.brighterplanet.com/bus_classes) that represents US averages.
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                BusClass.fallback
            end
          end
          
          #### Date (*date*)
          # *The day the trip occurred.*
          committee :date do
            # Use client input, if available.
            
            # Otherwise use the first day of `timeframe`.
            quorum 'from timeframe',
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                timeframe.from
            end
          end
        end
      end
    end
  end
end
