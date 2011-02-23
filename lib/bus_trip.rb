require 'emitter'

module BrighterPlanet
  module BusTrip
    extend BrighterPlanet::Emitter
    scope 'The bus trip emission estimate is the anthropogenic emissions per passenger from fuel and air conditioning used by the bus during the trip. It includes CO2 emissions from combustion of non-biogenic fuel, CH4 and N2O emissions from combustion of all fuel, and fugitive HFC emissions from air conditioning.'
  end
end
