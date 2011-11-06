Feature: Bus Trip Emissions Calculations
  The bus trip model should generate correct emission calculations
  
  Background:
    Given a bus_trip

  Scenario: Calculations for bus trip with nothing
    Given a bus trip has nothing
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "1.15"

  Scenario Outline: Calculations for bus trip from date
    Given it has "date" of "<date>"
    And it has "timeframe" of "<timeframe>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 1.15     |
      | 2010-06-01 | 2010-01-01/2010-05-31 | 0.0      |

  Scenario: Calculations for bus trip from distance
    Given it has "distance" of "100"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "14.37"

  Scenario: Calculations for bus trip from duration
    Given it has "duration" of "1800"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "2.29"

  Scenario: Calculations for bus trip from bus class
    Given it has "bus_class.name" of "city transit"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "0.88"

  Scenario: Calculations for bus trip from bus class and distance
    Given it has "bus_class.name" of "city transit"
    And it has "distance" of "10000"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "1469.93"
