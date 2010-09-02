Feature: Bus Trip Committee Calculations
  The bus trip model should generate correct committee calculations

  Scenario Outline: Distance from duration, distance estimate, and bus class
    Given a bus trip has "distance_estimate" of "<distance_estimate>"
    And it used "duration" "<duration>"
    And it used "bus_class.name" "<bus_class>"
    When emissions are calculated
    Then the distance committee should be close to <distance>, +/-1
    Examples:
      | duration | distance_estimate | bus_class      | distance |
      |       40 |                   |                |       21 |
      |          |     60            |                |       60 |
      |          |                   | regional coach |       21 |
      |          |                   | city transit   |        8 |
      
  Scenario Outline: Diesel consumed from distance and diesel intensity
    Given a bus trip has "distance_estimate" of "<distance_estimate>"
    And it used "duration" "<duration>"
    And it used "bus_class.name" "<bus_class>"
    When emissions are calculated
    Then the diesel_consumed committee should be close to <diesel_consumed>, +/-0.1
    Examples:
      | duration | distance_estimate | bus_class      | diesel_consumed |
      |       40 |                   |                |             7.0 |
      |          |     60            |                |            20.1 |
      |          |                   | regional coach |             5.0 |
      |          |                   | city transit   |             3.0 |
