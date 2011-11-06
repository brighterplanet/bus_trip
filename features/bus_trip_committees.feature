Feature: Bus Trip Committee Calculations
  The bus trip model should generate correct committee calculations

  Background:
    Given a bus_trip

  Scenario: Date committee from timeframe
    Given a characteristic "timeframe" of "2009-06-06/2010-01-01"
    When the "date" committee reports
    Then the committee should have used quorum "from timeframe"
    And the conclusion of the committee should be "2009-06-06"

  Scenario: Passengers from default bus class
    When the "bus_class" committee reports
    And the "passengers" committee reports
    Then the conclusion of the committee should be "7.485"
  
  Scenario: Passengers from bus class
    Given a characteristic "bus_class.name" of "city transit"
    When the "passengers" committee reports
    Then the conclusion of the committee should be "9.0"
  
  Scenario: Speed from default bus class
    When the "bus_class" committee reports
    And the "speed" committee reports
    Then the conclusion of the committee should be "31.94387"
  
  Scenario: Speed from bus class
    Given a characteristic "bus_class.name" of "city transit"
    When the "speed" committee reports
    Then the conclusion of the committee should be "21.0"
  
  Scenario: Distance from default bus class
    When the "bus_class" committee reports
    And the "distance" committee reports
    Then the committee should have used quorum "from bus class"
    And the conclusion of the committee should be "8.00262"
  
  Scenario: Distance from bus class
    Given a characteristic "bus_class.name" of "city transit"
    When the "distance" committee reports
    Then the committee should have used quorum "from bus class"
    And the conclusion of the committee should be "6.0"
  
  Scenario: Distance from duration and speed
    Given a characteristic "duration" of "1800"
    When the "bus_class" committee reports
    And the "speed" committee reports
    And the "distance" committee reports
    Then the committee should have used quorum "from duration and speed"
    And the conclusion of the committee should be "15.97193"

  Scenario Outline: Distance per passenger from distance, passengers, date, and timeframe
    Given a characteristic "distance" of "100"
    And a characteristic "passengers" of "10"
    And a characteristic "timeframe" of "<timeframe>"
    And a characteristic "date" of "<date>"
    When the "distance_per_passenger" committee reports
    Then the committee should have used quorum "from distance, passengers, date, and timeframe"
    And the conclusion of the committee should be "<distance>"
    Examples:
      | timeframe             | date       | distance |
      | 2010-01-01/2010-02-01 | 2010-01-31 | 10.0     |
      | 2010-01-01/2010-02-01 | 2010-02-01 | 0.0      |

  Scenario: Fuel uses from distance per passenger and default bus class
    Given a characteristic "distance_per_passenger" of "10"
    When the "bus_class" committee reports
    And the "fuel_uses" committee reports
    Then the committee should have used quorum "from distance per passenger and bus class"
    And the conclusion of the committee should include a key of "gasoline" and value "0.01509"
    And the conclusion of the committee should include a key of "diesel" and value "3.25443"
    And the conclusion of the committee should include a key of "cng" and value "0.74681"
    And the conclusion of the committee should include a key of "lng" and value "0.09855"
    And the conclusion of the committee should include a key of "lpg" and value "0.0087"
    And the conclusion of the committee should include a key of "methanol" and value "0.00494"
    And the conclusion of the committee should include a key of "biodiesel" and value "0.23028"

  Scenario: Fuel uses from distance per passenger and bus class
    Given a characteristic "distance_per_passenger" of "1000"
    And a characteristic "bus_class.name" of "city transit"
    When the "fuel_uses" committee reports
    Then the committee should have used quorum "from distance per passenger and bus class"
    And the conclusion of the committee should include a key of "gasoline" and value "3.0"
    And the conclusion of the committee should include a key of "diesel" and value "400.0"
    And the conclusion of the committee should include a key of "cng" and value "100.0"
    And the conclusion of the committee should include a key of "lng" and value "20.0"
    And the conclusion of the committee should include a key of "lpg" and value "2.0"
    And the conclusion of the committee should include a key of "methanol" and value "1.0"
    And the conclusion of the committee should include a key of "biodiesel" and value "40.0"

  Scenario: HFC emission from distance per passenger and default bus class
    Given a characteristic "distance_per_passenger" of "10"
    When the "bus_class" committee reports
    And the "hfc_emission" committee reports
    Then the committee should have used quorum "from distance per passenger and bus class"
    And the conclusion of the committee should be "0.29695"

  Scenario: HFC emission from distance per passenger and bus class
    Given a characteristic "distance_per_passenger" of "1000"
    And a characteristic "bus_class.name" of "city transit"
    When the "hfc_emission" committee reports
    Then the committee should have used quorum "from distance per passenger and bus class"
    And the conclusion of the committee should be "10.0"

  Scenario: N2O emission from distance per passenger and fuel uses
    Given a characteristic "distance_per_passenger" of "1000"
    And a characteristic "bus_class.name" of "city transit"
    When the "fuel_uses" committee reports
    And the "n2o_emission" committee reports
    Then the committee should have used quorum "from distance per passenger and fuel uses"
    And the conclusion of the committee should be "7.75249"

  Scenario: CH4 emission from distance per passenger and fuel uses
    Given a characteristic "distance_per_passenger" of "1000"
    And a characteristic "bus_class.name" of "city transit"
    When the "fuel_uses" committee reports
    And the "ch4_emission" committee reports
    Then the committee should have used quorum "from distance per passenger and fuel uses"
    And the conclusion of the committee should be "6.54527"

  Scenario: CO2 biogenic emission from distance per passenger and fuel uses
    Given a characteristic "distance_per_passenger" of "1000"
    And a characteristic "bus_class.name" of "city transit"
    When the "fuel_uses" committee reports
    And the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from fuel uses"
    And the conclusion of the committee should be "99.88200"

  Scenario: CO2 emission from distance per passenger and fuel uses
    Given a characteristic "distance_per_passenger" of "1000"
    And a characteristic "bus_class.name" of "city transit"
    When the "fuel_uses" committee reports
    And the "co2_emission" committee reports
    Then the committee should have used quorum "from fuel uses"
    And the conclusion of the committee should be "1298.63916"
