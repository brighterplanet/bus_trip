# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

## Bus trip carbon model
# This model is used by [Brighter Planet](http://brighterplanet.com)'s carbon emission [web service](http://carbon.brighterplanet.com) to estimate the **greenhouse gas emissions of passenger bus travel**.
#
##### Calculations
# The final estimate is the result of the **calculations** detailed below. These calculations are performed in reverse order, starting with the last calculation listed and finishing with the emission calculation. Each calculation is named according to the `value` it returns.
#
##### Methods
# To accomodate varying client input, each calculation may have one or more **methods**. These are listed under each calculation in order from most to least preferred. Each method is named according to the `values` it requires ('default' methods do not require any values). Methods are ignored if any of the values they require are unvailable. Calculations are ignored if all of their methods are unavailable.
#
##### Standard compliance
# Each method lists any established calculation standards with which it **complies**. When compliance with a standard is requested, all methods that do not comply with that standard are ignored. This means that any values a particular method requires will have been calculated using a compliant method or will be unavailable.
#
##### Collaboration
# Contributions to this carbon model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](http://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
module BrighterPlanet
  module BusTrip
    module CarbonModel
      def self.included(base)
        base.extend FastTimestamp
        base.decide :emission, :with => :characteristics do
          ### Emission calculation
          # Returns the `emission` estimate (*kg CO<sub>2</sub>e*)
          committee :emission do
            #### Emission from fuel, emission factors, and passengers
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # - Multiplies diesel consumed (*l*) by the diesel emission factor (*kg CO<sub>2</sub>e / l*) to give diesel emissions (*kg CO<sub>2</sub>e*)
            # - Multiplies alternaive fuel consumed (*l*) by the alternative fuels emission factor (*kg CO<sub>2</sub>e / l*) to give alternative fuels emissions (*kg CO<sub>2</sub>e*)
            # - Multiplies distance (*km*) by the air conditioning emission factor (*kg CO<sub>2</sub>e / km*) to give air conditioning emissions (*kg CO<sub>2</sub>e*)
            # - Sums the diesel, alternative fuels, and air conditioning emissions and divides by passengers to give emissions per passenger (*kg CO<sub>2</sub>e*)
            quorum 'from fuels, emission factors, and passengers', :needs => [:diesel_consumed, :diesel_emission_factor, :alternative_fuels_consumed, :alternative_fuels_emission_factor, :distance, :air_conditioning_emission_factor, :passengers] do |characteristics|
              (characteristics[:diesel_consumed] * characteristics[:diesel_emission_factor] + characteristics[:alternative_fuels_consumed] * characteristics[:alternative_fuels_emission_factor] + characteristics[:distance] * characteristics[:air_conditioning_emission_factor]) / characteristics[:passengers]
            end
          end
          
          ### Air conditioning emission factor calculation
          # Returns the `air conditioning emission factor` (*kg CO<sub>2</sub>e / km*).
          # This is used to account for fugitive emissions of air conditioning refrigerants.
          committee :air_conditioning_emission_factor do
            #### Air conditioning emission factor from bus class
            # **Complies:** GHG Protocol, ISO 14046-1, Climate Registry Protocol
            #
            # Looks up the [bus class](http://data.brighterplanet.com/bus_classes) `air conditioning emission factor` (*kg CO<sub>2</sub>e / km*).
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              characteristics[:bus_class].air_conditioning_emission_factor
            end
          end
          
          ### Diesel emission factor calculation
          # Returns the `diesel emission factor` (*kg CO<sub>2</sub>e / l*).
          committee :diesel_emission_factor do
            #### Default diesel emission factor
            # **Complies:** GHG Protocol, ISO 14046-1, Climate Registry Protocol
            #
            # Looks up [Distillate Fuel Oil 2](http://data.brighterplanet.com/fuel_types)'s `emission factor` (*kg CO<sub>2</sub>e / l*).
            quorum 'default' do
              diesel = FuelType.find_by_name "Distillate Fuel Oil 2"
              diesel.emission_factor
            end
          end
          
          ### Alternative fuels emission factor calculation
          # Returns the `alternative fuels emission factor` (*kg CO<sub>2</sub>e / l*).
          committee :alternative_fuels_emission_factor do
            #### Default alternative fuels emission factor
            # **Complies:** GHG Protocol, ISO 14046-1, Climate Registry Protocol
            #
            # Uses an `alternative fuels emission factor` of 1.17 *kg CO<sub>2</sub>e / l*.
            quorum 'default' do
              9.742.pounds_per_gallon.to(:kilograms_per_litre)
            end
          end
          
          ### Diesel consumed calculation
          # Returns the `diesel consumed` (*l*).
          committee :diesel_consumed do
            #### Diesel consumed from distance and diesel intensity
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Multiplies `distance` (*km*) by `diesel intensity` (*l / km*) to give *l*.
            quorum 'from distance and diesel intensity', :needs => [:distance, :diesel_intensity] do |characteristics|
              characteristics[:distance] * characteristics[:diesel_intensity]
            end
          end
          
          ### Alternative fuels consumed calculation
          # Returns the `alternative fuels consumed` (*l*).
          committee :alternative_fuels_consumed do
            #### Alternative fuels consumed from distance and alternative fuels intensity
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Multiplies `distance` (*km*) by `alternative fuels intensity` (*l / km*) to give *l*.
            quorum 'from distance and alternative fuels intensity', :needs => [:distance, :alternative_fuels_intensity] do |characteristics|
              characteristics[:distance] * characteristics[:alternative_fuels_intensity]
            end
          end
          
          ### Distance calculation
          # Returns the `distance` travelled (*km*).
          committee :distance do
            #### Distance from client input
            # **Complies:** All
            #
            # Uses the client-input `distance` (*km*).
            
            #### Distance from duration and speed
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Divides `duration` (*minutes*) by 60 and multiplies by `speed` (*km / hour*) to give *km*.
            quorum 'from duration and speed', :needs => [:duration, :speed] do |characteristics|
              characteristics[:duration] / 60 * characteristics[:speed]
            end
            
            #### Distance from bus class
            # **Complies:**
            #
            # Looks up the [bus class](http://data.brighterplanet.com/bus_classes) `distance` (*km*).
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              characteristics[:bus_class].distance
            end
          end
          
          ### Speed calculation
          # Returns the average `speed` (*km / hour*).
          committee :speed do
            #### Speed from bus class
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [bus class](http://data.brighterplanet.com/bus_classes)' average `speed` (*km / hour*).
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              characteristics[:bus_class].speed
            end
          end
          
          ### Duration calculation
          # Returns the trip's `duration` (*minutes*).
            #### Duration from client input
            # **Complies:** All
            #
            # Uses the client-input `duration` (*minutes*).
          
          ### Diesel intensity calculation
          # Returns the `diesel intensity` (*l / km*).
          committee :diesel_intensity do
            #### Diesel intensity from bus class
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [bus class](http://data.brighterplanet.com/bus_classes) `diesel intensity` (*l / km*).
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              characteristics[:bus_class].diesel_intensity
            end
          end
          
          ### Alternative fuels intensity calculation
          # Returns the `alternative fuels intensity` (*l / km*).
          committee :alternative_fuels_intensity do
            #### Alternative fuels intensity from bus class
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [bus class](http://data.brighterplanet.com/bus_classes) `alternative fuels intensity` (*l / km*).
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              characteristics[:bus_class].alternative_fuels_intensity
            end
          end
          
          ### Passengers calculation
          # Returns the number of `passengers` on the bus.
          committee :passengers do
            #### Passengers from bus class
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [bus class](http://data.brighterplanet.com/bus_classes)' average number of `passengers`.
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              characteristics[:bus_class].passengers
            end
          end
          
          ### Bus class calculation
          # Returns the `bus class`.
          # This is the type of bus used.
          committee :bus_class do
            #### From client input
            # **Complies:** All
            #
            # Uses the client-input [bus class](http://data.brighterplanet.com/bus_classes).
            
            #### Default bus class
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Uses an artificial [bus class](http://data.brighterplanet.com/bus_classes) that represents the U.S. average.
            quorum 'default' do
              BusClass.fallback
            end
          end
        end
      end
    end
  end
end
