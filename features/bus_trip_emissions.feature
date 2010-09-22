Feature: Bus Trip Emissions Calculations
  The bus trip model should generate correct emission calculations

  Scenario Outline: Calculations for bus trips with just timeframe and distance
    Given a bus trip has "distance_estimate" of "<distance>"
    And it has "timeframe" of "<timeframe>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | timeframe             | distance |  emission |
      | 2010-08-01/2010-08-01 |       10 |       1.2 |
      | 2010-08-01/2010-08-11 |      400 |      51.0 |

  Scenario Outline: Standard Calculations for bus trips with timeframe and bus class
    Given a bus trip has "distance_estimate" of "<distance>"
    And it has "bus_class.name" of "<bus_class>"
    And it has "timeframe" of "<timeframe>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | timeframe             | distance |      bus_class | emission |
      | 2010-08-01/2010-08-01 |       10 |   city transit |      3.4 |
      | 2010-08-01/2010-08-11 |      400 | regional coach |     51.4 |

  Scenario Outline: Calculations involving fuel types
    Given a bus trip has "distance_estimate" of "<distance>"
    And it has "bus_class.gasoline_intensity" of "<gasoline>"
    And it has "bus_class.diesel_intensity" of "<diesel>"
    And it has "bus_class.alternative_fuels_intensity" of "<alternative>"
    And it has "bus_class.passengers" of "<passengers>"
    And it has "bus_class.name" of "<bus_class>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | gasoline | diesel | alternative | passengers | distance | bus_class      | emission |
      |       40 |        |             |         25 |      328 | regional coach |     41.8 |
      |          |     60 |             |         85 |      623 | regional coach |     79.5 |
      |          |     10 |          10 |        120 |       11 | city transit   |      1.4 |
      |          |     20 |             |         20 |       11 | city transit   |      1.4 |
