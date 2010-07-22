Feature: Bus Trip Committee Calculations
  The bus trip model should generate correct committee calculations

  Scenario Outline: Standard Calculations for bus trip
    Given a bus trip has "distance" of "<source>"
    And it used "gasoline_consumed" "<gasoline>"
    And it used "diesel_consumed" "<diesel>"
    And it used "alternative_fuels_consumed" "<alternative>"
    And it has "passengers" "<passengers>"
    And it has "distance" of "<distance>"
    And it has "bus_class.name" "<bus_class>"
    When emissions are calculated
    Then the fuel committee should be close to <fuel>, +/-1
    And the fuel_per_segment committee should be close to <fuel_per_segment>, +/-10
    And the adjusted_distance_per_segment committee should be close to <adjusted_distance_per_segment>, +/-1
    And the load_factor committee should be close to <load_factor>, +/-0.001
    And the passengers committee should be exactly <passengers>
    And the adjusted_distance committee should be close to <adjusted_distance>, +/-1
    Examples:
      | gasoline | diesel | alternative | passengers | distance | bus_class      |
      |       40 |        |             |         25 |      328 | regional coach |
      |          |     60 |             |         85 |      623 | regional coach |
      |          |     10 |          10 |        120 |       11 | city transit   |
