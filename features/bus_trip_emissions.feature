Feature: Bus Trip Emissions Calculations
  The bus trip model should generate correct emission calculations
  
  Scenario: Calculations for bus trip with nothing
    Given a bus trip has nothing
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "0.87"
  
  Scenario: Calculations for bus trip from distance
    Given a bus trip has "distance" of "100"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "9.95"
  
  Scenario: Calculations for bus trip from duration
    Given a bus trip has "duration" of "60"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "3.15"
  
  Scenario: Calculations for bus trip from bus class
    Given a bus trip has "bus_class.name" of "city transit"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2.64"
