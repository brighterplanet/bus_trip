module BrighterPlanet
  module BusTrip
    def self.included(base)
      base.extend ::Leap::Subject
      base.decide :emission, :with => :characteristics do
        committee :emission do # returns kg CO2
          quorum 'from fuel and passengers', :needs => [:diesel_consumed, :gasoline_consumed, :alternative_fuels_consumed, :passengers, :distance, :bus_class] do |characteristics|
            #((       litres diesel         ) * (  kilograms CO2 / litre diesel   ) + (       litres gasoline          ) * (     kilograms CO2 / kWh            ) + (     litre-equivs alternative fuel       ) * (kilograms CO2 / litre-equiv alternative fuel))
            (characteristics[:diesel_consumed] * research(:diesel_emission_factor) + characteristics[:gasoline_consumed] * research(:gasoline_emission_factor) + characteristics[:alternative_fuels_consumed] * research(:alternative_fuels_emission_factor) + characteristics[:distance] * characteristics[:bus_class].fugitive_air_conditioning_emission) / characteristics[:passengers]
          end
        end
        
        committee :diesel_consumed do # returns litres diesel
          quorum 'from distance and diesel intensity', :needs => [:distance, :diesel_intensity] do |characteristics|
            #(          kilometres        ) * (     litres diesel / kilometre      )
            characteristics[:distance] * characteristics[:diesel_intensity]
          end
        end
        
        committee :gasoline_consumed do # returns litres gasoline
          quorum 'from distance and gasoline intensity', :needs => [:distance, :gasoline_intensity] do |characteristics|
            #(          kilometres        ) * (     litres gasoline / kilometre      )
            characteristics[:distance] * characteristics[:gasoline_intensity]
          end
        end
        
        committee :alternative_fuels_consumed do # returns litres alternative_fuels
          quorum 'from distance and alternative fuels intensity', :needs => [:distance, :alternative_fuels_intensity] do |characteristics|
            #(          kilometres        ) * (     litres alternative_fuels / kilometre      )
            characteristics[:distance] * characteristics[:alternative_fuels_intensity]
          end
        end
        
        committee :distance do # returns kilometres
          quorum 'from distance estimate', :needs => :distance_estimate do |characteristics|
            characteristics[:distance_estimate]
          end
          
          quorum 'from duration', :needs => [:duration, :speed] do |characteristics|
            #(       minutes         ) * (        kph          )
            characteristics[:duration] * characteristics[:speed] / 60
          end
          
          quorum 'from bus class', :needs => :bus_class do |characteristics|
            characteristics[:bus_class].distance
          end
        end
        
        committee :diesel_intensity do # returns litres diesel / vehicle kilometre
          quorum 'from bus class', :needs => :bus_class do |characteristics|
            characteristics[:bus_class].diesel_intensity
          end
        end
        
        committee :gasoline_intensity do # returns litres gasoline / vehicle kilometre
          quorum 'from bus class', :needs => :bus_class do |characteristics|
            characteristics[:bus_class].gasoline_intensity
          end
        end
        
        committee :alternative_fuels_intensity do # returns litres alternative_fuels / vehicle kilometre
          quorum 'from bus class', :needs => :bus_class do |characteristics|
            characteristics[:bus_class].alternative_fuels_intensity
          end
        end
        
        committee :speed do # returns kph
          quorum 'from bus class', :needs => :bus_class do |characteristics|
            characteristics[:bus_class].speed
          end
        end
        
        committee :passengers do
          quorum 'from bus class', :needs => :bus_class do |characteristics|
            characteristics[:bus_class].passengers
          end
        end
        
        committee :bus_class do
          quorum 'default' do
            BusClass.fallback
          end
        end
      end
    end
  end
end