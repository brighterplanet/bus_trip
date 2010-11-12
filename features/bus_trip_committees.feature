Feature: Bus Trip Committee Calculations
  The bus trip model should generate correct committee calculations
  
  Scenario: Passengers from bus class
    Given a bus trip emitter
    And a characteristic "bus_class.name" of "city transit"
    When the "passengers" committee is calculated
    Then the conclusion of the committee should be "10.4"
  
  Scenario: Speed from bus class
    Given a bus trip emitter
    And a characteristic "bus_class.name" of "city transit"
    When the "speed" committee is calculated
    Then the conclusion of the committee should be "24.0919"
  
  Scenario: Alternative fuels intensity from bus class
    Given a bus trip emitter
    And a characteristic "bus_class.name" of "city transit"
    When the "alternative_fuels_intensity" committee is calculated
    Then the conclusion of the committee should be "2.11693"
  
  Scenario: Diesel intensity from bus class
    Given a bus trip emitter
    And a characteristic "bus_class.name" of "city transit"
    When the "diesel_intensity" committee is calculated
    Then the conclusion of the committee should be "0.423386"
  
  Scenario: Distance from duration and speed
    Given a bus trip emitter
    And a characteristic "duration" of "60"
    And a characteristic "bus_class.name" of "city transit"
    When the "speed" committee is calculated
    And the "distance" committee is calculated
    Then the committee should have used quorum "from duration and speed"
    And the conclusion of the committee should be "24.0919"
  
  Scenario: Distance from bus class
    Given a bus trip emitter
    And a characteristic "bus_class.name" of "city transit"
    When the "distance" committee is calculated
    Then the committee should have used quorum "from bus class"
    Then the conclusion of the committee should be "7.19377"
  
  Scenario: Alternative fuels consumed from distance and alternative fuels intensity
    Given a bus trip emitter
    And a characteristic "alternative_fuels_intensity" of "2"
    And a characteristic "distance" of "10"
    When the "alternative_fuels_consumed" committee is calculated
    Then the conclusion of the committee should be "20"
  
  Scenario: Diesel consumed from distance and diesel intensity
    Given a bus trip emitter
    And a characteristic "diesel_intensity" of "2"
    And a characteristic "distance" of "10"
    When the "diesel_consumed" committee is calculated
    Then the conclusion of the committee should be "20"
  
  Scenario: Alternative fuels emission factor from default
    Given a bus trip emitter
    When the "alternative_fuels_emission_factor" committee is calculated
    Then the conclusion of the committee should be "1.16735"
  
  Scenario: Diesel emission factor from default
    Given a bus trip emitter
    When the "diesel_emission_factor" committee is calculated
    Then the conclusion of the committee should be "2.0"

  Scenario: Air conditioning emission factor from bus class
    Given a bus trip emitter
    And a characteristic "bus_class.name" of "city transit"
    When the "air_conditioning_emission_factor" committee is calculated
    Then the conclusion of the committee should be "0.5"
