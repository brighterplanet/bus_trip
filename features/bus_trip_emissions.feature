Feature: Bus Trip Emissions Calculations
  The bus trip model should generate correct emission calculations
  
  Scenario: Calculations for bus trip with nothing
    Given a bus trip has nothing
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "1.11982"
  
  Scenario: Calculations for bus trip from distance estimate
    Given a bus trip has "distance_estimate" of "100"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "12.76743"
  
  Scenario: Calculations for bus trip from duration
    Given a bus trip has "duration" of "60"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "4.04163"
  
  Scenario: Calculations for bus trip from bus class
    Given a bus trip has "bus_class.name" of "city transit"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "2.49714"
