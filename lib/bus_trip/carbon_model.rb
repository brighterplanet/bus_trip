# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

## Bus trip carbon model
# This model is used by [Brighter Planet](http://brighterplanet.com)'s carbon emission [web service](http://carbon.brighterplanet.com) to estimate the **greenhouse gas emissions of passenger bus travel**.
#
##### Calculations
# The final estimate is the result of the **calculations** detailed below. These calculations are performed in reverse order, starting with the last calculation listed and finishing with the `emission` calculation. Each calculation is named according to the value it returns.
#
##### Methods
# To accomodate varying client input, each calculation may have one or more **methods**. These are listed under each calculation in order from most to least preferred. Each method is named according to the values it requires. If any of these values is not available the method will be ignored. If all the methods for a calculation are ignored, the calculation will not return a value. "Default" methods do not require any values, and so a calculation with a default method will always return a value.
#
##### Standard compliance
# Each method lists any established calculation standards with which it **complies**. When compliance with a standard is requested, all methods that do not comply with that standard are ignored. This means that any values a particular method requires will have been calculated using a compliant method, because those are the only methods available. If any value did not have a compliant method in its calculation then it would be undefined, and the current method would have been ignored.
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
            #### Emission from fuel and passengers
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # - Uses a diesel emission factor of 2.69 *kg CO<sub>2</sub>e / l diesel*
            # - Multiplies `diesel consumed` (*l*) by the diesel emission factor (*kg CO<sub>2</sub>e / l diesel*) to give diesel emissions (*kg CO<sub>2</sub>e*)
            # - Uses a gasoline emission factor of 2.84 *kg CO<sub>2</sub>e / l gasoline*
            # - Multiplies `gasoline consumed` (*l*) by the gasoline emission factor (*kg CO<sub>2</sub>e / l gasoline*) to give gasoline emissions (*kg CO<sub>2</sub>e*)
            # - Uses an alternative fuel emission factor of 1.17 *kg CO<sub>2</sub>e / l fuel*
            # - Multiplies `alternaive fuel consumed` (*l*) by the alternative fuel emission factor (*kg CO<sub>2</sub>e / l fuel*) to give alternative fuel emissions (*kg CO<sub>2</sub>e*)
            # - Looks up the [bus class](http://data.brighterplanet.com/bus_classes) fugitive air conditioning emission factor (*kg CO<sub>2</sub>e / km*)
            # - Multiplies `distance` (*km*) by the fugitive air conditioning emission factor (*kg CO<sub>2</sub>e / km*) to give fugitive air conditioning emissions (*kg CO<sub>2</sub>e*)
            # - Sums the diesel, gasoline, alternative fuel, and fugitive air conditioning emissions
            # - Divides by passengers to give emissions per passenger (*kg CO<sub>2</sub>e)
            quorum 'from fuel and passengers', :needs => [:diesel_consumed, :gasoline_consumed, :alternative_fuels_consumed, :passengers, :distance, :bus_class] do |characteristics|
              (characteristics[:diesel_consumed] * 22.450.pounds_per_gallon.to(:kilograms_per_litre) + characteristics[:gasoline_consumed] * 23.681.pounds_per_gallon.to(:kilograms_per_litre) + characteristics[:alternative_fuels_consumed] * 9.742.pounds_per_gallon.to(:kilograms_per_litre) + characteristics[:distance] * characteristics[:bus_class].fugitive_air_conditioning_emission) / characteristics[:passengers]
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
          
          ### Gasoline consumed calculation
          # Returns the `gasoline consumed` (*l*).
          committee :gasoline_consumed do
            #### Gasoline consumed from distance and gasoline intensity
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Multiplies `distance` (*km*) by `gasoline intensity` (*l / km*) to give *l*.
            quorum 'from distance and gasoline intensity', :needs => [:distance, :gasoline_intensity] do |characteristics|
              characteristics[:distance] * characteristics[:gasoline_intensity]
            end
          end
          
          ### Alternative fuel consumed calculation
          # Returns the `alternative fuel consumed` (*l*).
          committee :alternative_fuels_consumed do
            #### Alternative fuel consumed from distance and alternative fuel intensity
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Multiplies `distance` (*km*) by `alternative fuel intensity` (*l / km*) to give *l*.
            quorum 'from distance and alternative fuels intensity', :needs => [:distance, :alternative_fuels_intensity] do |characteristics|
              characteristics[:distance] * characteristics[:alternative_fuels_intensity]
            end
          end
          
          ### Distance calculation
          # Returns the `distance` travelled (*km*).
          committee :distance do
            #### Distance from client input
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Uses the client-input `distance estimate` (*km*).
            quorum 'from distance estimate', :needs => :distance_estimate do |characteristics|
              characteristics[:distance_estimate]
            end
            
            #### Distance from duration
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Divides `duration` (*minutes*) by 60 and multiplies by `speed` (*km / hour*) to give *km*.
            quorum 'from duration', :needs => [:duration, :speed] do |characteristics|
              characteristics[:duration] / 60 * characteristics[:speed]
            end
            
            #### Distance from bus class
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [bus class](http://data.brighterplanet.com/bus_classes) `distance` (*km*).
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              characteristics[:bus_class].distance
            end
          end
          
          ### Distance estimate calculation
          # Returns the `distance estimate` (*km*).
            #### Distance estimte from client input
            # **Complies:** All
            #
            # Uses the client-input `distance estimate` (*km*).
          
          ### Duration calculation
          # Returns the bus trip's `duration` (*minutes*).
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
          
          ### Gasoline intensity calculation
          # Returns the `gasoline intensity` (*l / km*).
          committee :gasoline_intensity do
            #### Gasoline intensity from bus class
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [bus class](http://data.brighterplanet.com/bus_classes) `gasoline intensity` (*l / km*).
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              characteristics[:bus_class].gasoline_intensity
            end
          end
          
          ### Alternative fuel intensity calculation
          # Returns the `alternative fuel intensity` (*l / km*).
          committee :alternative_fuels_intensity do
            #### Alternative fuel intensity from bus class
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [bus class](http://data.brighterplanet.com/bus_classes) `alternative fuel intensity` (*l / km*).
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              characteristics[:bus_class].alternative_fuels_intensity
            end
          end
          
          ### Speed calculation
          # Returns the average `speed` (*km / hour*).
          committee :speed do
            # Speed from bus class
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [bus class](http://data.brighterplanet.com/bus_classes) `speed` (*km / hour*).
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              characteristics[:bus_class].speed
            end
          end
          
          ### Passengers calculation
          # Returns the total number of `passengers`.
          committee :passengers do
            #### Passengers from bus class
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [bus class](http://data.brighterplanet.com/bus_classes) `passengers`.
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
            # Uses U.S. averages.
            quorum 'default' do
              BusClass.fallback
            end
          end
        end
      end
    end
  end
end
