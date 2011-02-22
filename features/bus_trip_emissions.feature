Feature: Bus Trip Emissions Calculations
  The bus trip model should generate correct emission calculations
  
  Scenario: Calculations for bus trip with nothing
    Given a bus trip has nothing
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1.15"
  
  Scenario Outline: Calculations for bus trip from date
    Given a bus trip has "date" of "<date>"
    And it has "timeframe" of "<timeframe>"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 1.15     |
      | 2010-06-01 | 2010-01-01/2010-05-31 | 0.0      |

  Scenario: Calculations for bus trip from distance
    Given a bus trip has "distance" of "100"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "14.37"
  
  Scenario: Calculations for bus trip from duration
    Given a bus trip has "duration" of "30"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2.29"
  
  Scenario: Calculations for bus trip from bus class
    Given a bus trip has "bus_class.name" of "city transit"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "0.95"
