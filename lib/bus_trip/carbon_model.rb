# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

## Bus trip carbon model
# This model is used by [Brighter Planet](http://brighterplanet.com)'s carbon emission [web service](http://carbon.brighterplanet.com) to estimate the **greenhouse gas emissions of passenger bus travel**.
#
##### Timeframe and activity period
# The model estimates the emissions that occur during a particular `timeframe`. To do this it needs to know the `date` on which the trip occurred. For example, if the `timeframe` is January 2010, a trip that occurred on January 5, 2010 will have emissions but a trip that occurred on February 1, 2010 will not.
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
        base.decide :emission, :with => :characteristics do
          ### Emission calculation
          # Returns the `emission` estimate (*kg CO<sub>2</sub>e*)
          committee :emission do
            #### Emission from CO<sub>2</sub> emission, CH<sub>4</sub> emission, N<sub>2</sub>O emission, and HFC emission
            quorum 'from co2 emission, ch4 emission, n2o emission, and hfc emission',
              :needs => [:co2_emission, :ch4_emission, :n2o_emission, :hfc_emission],
              # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
              # - Sums the non-biogenic emissions to give *kg CO<sub>2</sub>e*.
              characteristics[:co2_emission] + characteristics[:ch4_emission] + characteristics[:n2o_emission] + characteristics[:hfc_emission]
            end
          end
          
          ### CO<sub>2</sub> emission calculation
          # Returns the `co2 emission` per passenger (*kg / l*).
          committee :co2_emission do
            #### CO<sub>2</sub> emission from distance, bus class, passengers, date, and timeframe
            quorum 'from distance, bus class, passengers, date, and timeframe',
              :needs => [:distance, :bus_class, :date, :passengers],
              # **Complies:** GHG Protocol Scope 3, ISO 14046-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                # Checks whether the trip `date` falls within the `timeframe`.
                date = characteristics[:date].is_a?(Date) ?
                  characteristics[:date] :
                  Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                  # Multiplies each fuel intensity (*l / km*) for the [bus class](http://data.brighterplanet.com/bus_classes) by that [fuel](http://data.brighterplanet.com/bus_fuels)'s `co2 emission factor` (*kg / l*) and sums to give a combined `co2 emission factor` (*kg / km*).
                  combined_ef = characteristics[:bus_class].gasoline_intensity * BusFuel.find_by_name("Gasoline").co2_emission_factor +
                                characteristics[:bus_class].diesel_intensity * BusFuel.find_by_name("Diesel").co2_emission_factor +
                                characteristics[:bus_class].cng_intensity * BusFuel.find_by_name("CNG").co2_emission_factor +
                                characteristics[:bus_class].lng_intensity * BusFuel.find_by_name("LNG").co2_emission_factor +
                                characteristics[:bus_class].lpg_intensity * BusFuel.find_by_name("LPG").co2_emission_factor +
                                characteristics[:bus_class].methanol_intensity * BusFuel.find_by_name("Methanol").co2_emission_factor +
                                characteristics[:bus_class].biodiesel_intensity * BusFuel.find_by_name("Biodiesel").co2_emission_factor
                  # Multiplies distance (*km*) by the combined `co2 emission factor` (*kg / km*) and divides by `passengers` to give *kg*.
                  characteristics[:distance] * combined_ef / characteristics[:passengers]
                else
                  # If the `date` does not fall within the `timeframe`, `co2 emission` is zero.
                  0
                end
            end
          end
          
          ### CO<sub>2</sub> biogenic emission calculation
          # Returns the `co2 biogenic emission` (*kg / l*).
          committee :co2_biogenic_emission do
            #### CO<sub>2</sub> biogenic emission from distance, bus class, passengers, date, and timeframe
            quorum 'from distance, bus class, passengers, date, and timeframe',
              :needs => [:distance, :bus_class, :date, :passengers],
              # **Complies:** GHG Protocol Scope 3, ISO 14046-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                # Checks whether the trip `date` falls within the `timeframe`.
                date = characteristics[:date].is_a?(Date) ?
                  characteristics[:date] :
                  Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                  # Multiplies each fuel intensity (*l / km*) for the [bus class](http://data.brighterplanet.com/bus_classes) by that [fuel](http://data.brighterplanet.com/bus_fuels)'s `co2 biogenic emission factor` (*kg / l*) and sums to give a combined `co2 biogenic emission factor` (*kg / km*).
                  combined_ef = characteristics[:bus_class].gasoline_intensity * BusFuel.find_by_name("Gasoline").co2_biogenic_emission_factor +
                                characteristics[:bus_class].diesel_intensity * BusFuel.find_by_name("Diesel").co2_biogenic_emission_factor +
                                characteristics[:bus_class].cng_intensity * BusFuel.find_by_name("CNG").co2_biogenic_emission_factor +
                                characteristics[:bus_class].lng_intensity * BusFuel.find_by_name("LNG").co2_biogenic_emission_factor +
                                characteristics[:bus_class].lpg_intensity * BusFuel.find_by_name("LPG").co2_biogenic_emission_factor +
                                characteristics[:bus_class].methanol_intensity * BusFuel.find_by_name("Methanol").co2_biogenic_emission_factor +
                                characteristics[:bus_class].biodiesel_intensity * BusFuel.find_by_name("Biodiesel").co2_biogenic_emission_factor
                  # Multiplies distance (*km*) by the combined `co2 biogenic emission factor` (*kg / km*) and divides by `passengers` to give *kg*.
                  characteristics[:distance] * combined_ef / characteristics[:passengers]
                else
                  # If the `date` does not fall within the `timeframe`, `co2 biogenic emission` is zero.
                  0
                end
            end
          end
          
          ### CH<sub>4</sub> emission calculation
          # Returns the `ch4 emission` (*kg co2e / l*).
          committee :ch4_emission do
            #### CH<sub>4</sub> emission from distance, bus class, passengers, date, and timeframe
            quorum 'from distance, bus class, passengers, date, and timeframe',
              :needs => [:distance, :bus_class, :passengers, :date],
              # **Complies:** GHG Protocol Scope 3, ISO 14046-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                # Checks whether the trip `date` falls within the `timeframe`.
                date = characteristics[:date].is_a?(Date) ?
                  characteristics[:date] :
                  Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                  # Multiplies each fuel intensity (*l / km*) for the [bus class](http://data.brighterplanet.com/bus_classes) by that [fuel](http://data.brighterplanet.com/bus_fuels)'s `ch4 emission factor` (*kg CO<sub>2</sub>e / km*) and sums to give a combined `ch4 emission factor` (*kg CO<sub>2</sub>e l / km<sup>2</sup>*).
                  combined_ef = characteristics[:bus_class].gasoline_intensity * BusFuel.find_by_name("Gasoline").ch4_emission_factor +
                                characteristics[:bus_class].diesel_intensity * BusFuel.find_by_name("Diesel").ch4_emission_factor +
                                characteristics[:bus_class].cng_intensity * BusFuel.find_by_name("CNG").ch4_emission_factor +
                                characteristics[:bus_class].lng_intensity * BusFuel.find_by_name("LNG").ch4_emission_factor +
                                characteristics[:bus_class].lpg_intensity * BusFuel.find_by_name("LPG").ch4_emission_factor +
                                characteristics[:bus_class].methanol_intensity * BusFuel.find_by_name("Methanol").ch4_emission_factor +
                                characteristics[:bus_class].biodiesel_intensity * BusFuel.find_by_name("Biodiesel").ch4_emission_factor
                  # Adds the individual fuel intensities for the [bus class](http://data.brighterplanet.com/bus_classes) to give `total fuel intensity` (*l / km*).
                  total_intensity = characteristics[:bus_class].gasoline_intensity +
                                    characteristics[:bus_class].diesel_intensity +
                                    characteristics[:bus_class].cng_intensity +
                                    characteristics[:bus_class].lng_intensity +
                                    characteristics[:bus_class].lpg_intensity +
                                    characteristics[:bus_class].methanol_intensity +
                                    characteristics[:bus_class].biodiesel_intensity
                  # Divides the combined `ch4 emission factor` (*kg CO<sub>2</sub>e l / km<sup>2</sup>*) by the total intensity (*l / km*), multiplies by distance (*km*), and divides by `passengers` to give *kg CO<sub>2</sub>e*.
                  # (This distributes the total travel between the various fuels; we need to do this because the `ch4 emission factor` is emission per unit distance rather than per unit fuel.)
                  (characteristics[:distance] * (combined_ef / total_intensity)) / characteristics[:passengers]
                else
                  # If the `date` does not fall within the `timeframe`, `ch4 emission` is zero.
                  0
                end
            end
          end
          
          ### N<sub>2</sub>O emission calculation
          # Returns the `n2o emission` (*kg CO<sub>2</sub>e / l*).
          committee :n2o_emission do
            #### N<sub>2</sub>O emission from distance, bus class, passengers, date, and timeframe
            quorum 'from distance, bus class, passengers, date, and timeframe',
              :needs => [:distance, :bus_class, :passengers, :date],
              # **Complies:** GHG Protocol Scope 3, ISO 14046-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                # Checks whether the trip `date` falls within the `timeframe`.
                date = characteristics[:date].is_a?(Date) ?
                  characteristics[:date] :
                  Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                  # Multiplies each fuel intensity (*l / km*) for the [bus class](http://data.brighterplanet.com/bus_classes) by that [fuel](http://data.brighterplanet.com/bus_fuels)'s `n2o emission factor` (*kg CO<sub>2</sub>e / km*) and sums to give a combined `n2o emission factor` (*kg CO<sub>2</sub>e l / km<sup>2</sup>*).
                  combined_ef = characteristics[:bus_class].gasoline_intensity * BusFuel.find_by_name("Gasoline").n2o_emission_factor +
                                characteristics[:bus_class].diesel_intensity * BusFuel.find_by_name("Diesel").n2o_emission_factor +
                                characteristics[:bus_class].cng_intensity * BusFuel.find_by_name("CNG").n2o_emission_factor +
                                characteristics[:bus_class].lng_intensity * BusFuel.find_by_name("LNG").n2o_emission_factor +
                                characteristics[:bus_class].lpg_intensity * BusFuel.find_by_name("LPG").n2o_emission_factor +
                                characteristics[:bus_class].methanol_intensity * BusFuel.find_by_name("Methanol").n2o_emission_factor +
                                characteristics[:bus_class].biodiesel_intensity * BusFuel.find_by_name("Biodiesel").n2o_emission_factor
                  # Adds the individual fuel intensities for the [bus class](http://data.brighterplanet.com/bus_classes) to give `total fuel intensity` (*l / km*).
                  total_intensity = characteristics[:bus_class].gasoline_intensity +
                                    characteristics[:bus_class].diesel_intensity +
                                    characteristics[:bus_class].cng_intensity +
                                    characteristics[:bus_class].lng_intensity +
                                    characteristics[:bus_class].lpg_intensity +
                                    characteristics[:bus_class].methanol_intensity +
                                    characteristics[:bus_class].biodiesel_intensity
                  # Divides the combined `n2o emission factor` (*kg CO<sub>2</sub>e l / km<sup>2</sup>*) by the total intensity (*l / km*), multiplies by distance (*km*), and divides by `passengers` to give *kg CO<sub>2</sub>e*.
                  # (This distributes the total travel between the various fuels; we need to do this because the `n2o emission factor` is emission per unit distance rather than per unit fuel.)
                  combined_ef / total_intensity * characteristics[:distance] / characteristics[:passengers]
                else
                  # If the `date` does not fall within the `timeframe`, `n2o emission` is zero.
                  0
                end
            end
          end
          
          ### HFC emission calculation
          # Returns the `hfc emission` (*kg CO<sub>2</sub>*).
          committee :hfc_emission do
            #### HFC emission from distance, bus class, passengers, date, and timeframe
            quorum 'from distance, bus class, passengers, date, and timeframe',
              :needs => [:distance, :bus_class, :passengers, :date],
              # **Complies:** GHG Protocol Scope 3, ISO 14046-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                # Checks whether the trip `date` falls within the `timeframe`.
                date = characteristics[:date].is_a?(Date) ?
                  characteristics[:date] :
                  Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                  # Looks up `HFC emission factor` (*kg CO<sub>2</sub>e / km*) for the [bus class](http://data.brighterplanet.com/bus_classes), multiplies by the `distance` (*km*), and divides by `passengers` to give *kg CO<sub>2</sub>e*.
                  characteristics[:distance] * characteristics[:bus_class].air_conditioning_emission_factor / characteristics[:passengers]
                else
                  # If the `date` does not fall within the `timeframe`, `HFC emission` is zero.
                  0
                end
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
            # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
            quorum 'from duration and speed', :needs => [:duration, :speed], :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
              # Divides `duration` (*minutes*) by 60 (*minutes / hour*) and multiplies by `speed` (*km / hour*) to give *km*.
              characteristics[:duration] / 60.0 * characteristics[:speed]
            end
            
            #### Distance from bus class
            # **Complies:**
            quorum 'from bus class', :needs => :bus_class do |characteristics|
              # Looks up the [bus class](http://data.brighterplanet.com/bus_classes) `distance` (*km*).
              characteristics[:bus_class].distance
            end
          end
          
          ### Speed calculation
          # Returns the average `speed` (*km / hour*).
          committee :speed do
            #### Speed from bus class
            # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
            quorum 'from bus class', :needs => :bus_class, :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
              # Looks up the [bus class](http://data.brighterplanet.com/bus_classes)' average `speed` (*km / hour*).
              characteristics[:bus_class].speed
            end
          end
          
          ### Duration calculation
          # Returns the trip's `duration` (*minutes*).
            #### Duration from client input
            # **Complies:** All
            #
            # Uses the client-input `duration` (*minutes*).
          
          ### Passengers calculation
          # Returns the number of `passengers` on the bus.
          committee :passengers do
            #### Passengers from bus class
            # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
            quorum 'from bus class', :needs => :bus_class, :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
              # Looks up the [bus class](http://data.brighterplanet.com/bus_classes)' average number of `passengers`.
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
            # **Complies:** GHG Protocol Scope 3, ISO 14064-1, Climate Registry Protocol
            quorum 'default', :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
              # Uses a fallback [bus class](http://data.brighterplanet.com/bus_classes) that represents the U.S. average.
              BusClass.fallback
            end
          end
          
          ### Date calculation
          # Returns the `date` on which the trip occurred.
          committee :date do
            #### Date from client input
            # **Complies:** All
            #
            # Uses the client-input `date`.
            
            #### Date from timeframe
            quorum 'from timeframe',
              # **Complies:** GHG Protocol Scope 3, ISO-14064-1, Climate Registry Protocol
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                # Assumes the trip occurred on the first day of the `timeframe`.
                timeframe.from
            end
          end
          
          ### Timeframe calculation
          # Returns the `timeframe`.
          # This is the period during which to calculate emissions.
            
            #### Timeframe from client input
            # **Complies:** All
            #
            # Uses the client-input `timeframe`.
            
            #### Default timeframe
            # **Complies:** All
            #
            # Uses the current calendar year.
        end
      end
    end
  end
end
