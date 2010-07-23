Feature: Bus Trip Emissions Calculations
  The bus trip model should generate correct emission calculations

  Scenario Outline: Standard Calculations for bus trips
    Given a bus trip has "distance" of "<source>"
    And it used "bus_class.gasoline_intensity" "<gasoline>"
    And it used "bus_class.diesel_intensity" "<diesel>"
    And it used "bus_class.alternative_fuels_intensity" "<alternative>"
    And it has "bus_class.passengers" "<passengers>"
    And it has "distance_estimate" of "<distance>"
    And it has "bus_class.name" "<bus_class>"
    When emissions are calculated
    Then the emission value should be within 0.1 kgs of <emission>
    Examples:
      | gasoline | diesel | alternative | passengers | distance | bus_class      | emission |
      |       40 |        |             |         25 |      328 | regional coach |     41.8 |
      |          |     60 |             |         85 |      623 | regional coach |     79.5 |
      |          |     10 |          10 |        120 |       11 | city transit   |      1.4 |
      |          |     20 |             |         20 |       11 | city transit   |      1.4 |
