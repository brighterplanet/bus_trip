Feature: Bus Trip Emissions Calculations
  The bus trip model should generate correct emission calculations

  Scenario Outline: Standard Calculations for bus trips
    Given a bus trip has "distance" of "<source>"
    And it used "gasoline_consumed" "<gasoline>"
    And it used "diesel_consumed" "<diesel>"
    And it used "alternative_fuels_consumed" "<alternative>"
    And it has "passengers" "<passengers>"
    And it has "distance" of "<distance>"
    And it has "bus_class.name" "<bus_class>"
    When emissions are calculated
    Then the emission value should be within 10 kgs of <emission>
    Examples:
      | gasoline | diesel | alternative | passengers | distance | bus_class      |
      |       40 |        |             |         25 |      328 | regional coach |
      |          |     60 |             |         85 |      623 | regional coach |
      |          |     10 |          10 |        120 |       11 | city transit   |
