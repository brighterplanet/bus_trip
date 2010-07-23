Feature: Bus Trip Committee Calculations
  The bus trip model should generate correct committee calculations

  Scenario Outline: Standard Calculations for bus trip
    Given a bus trip has "distance" of "<distance_estimate>"
    And it used "duration" "<duration>"
    And it used "bus_class.name" "<bus_class>"
    When emissions are calculated
    Then the distance committee should be close to <distance>, +/-1
    Examples:
      | duration | distance_estimate | bus_class      | distance |
      |       40 |                   |                |       21 |
      |          |     60            |                |        8 |
      |          |                   | regional coach |       21 |
      |          |                   | city transit   |        8 |
