Feature: Bus Trip Committee Calculations
  The bus trip model should generate correct committee calculations

  Scenario Outline: Distance from duration, distance estimate, and bus class
    Given a bus trip emitter
    And a characteristic "distance_estimate" of "<distance_estimate>"
    And a characteristic "duration" of "<duration>"
    And a characteristic "bus_class.name" of "<bus_class>"
    When the "bus_class" committee is calculated
    And the "distance" committee is calculated
    Then the conclusion of the committee should be "<distance>"
    Examples:
      | duration | distance_estimate | bus_class      | distance |
      |       40 |                   |                |        8 |
      |          |     60            |                |       60 |
      |          |                   | regional coach |        8 |
      |          |                   | city transit   |        8 |
      
  Scenario Outline: Diesel consumed from distance and diesel intensity
    Given a bus trip emitter
    And a characteristic "distance_estimate" of "<distance_estimate>"
    And a characteristic "duration" of "<duration>"
    And a characteristic "bus_class.name" of "<bus_class>"
    When the "distance" committee is calculated
    And the "diesel_intensity" committee is calculated
    And the "diesel_consumed" committee is calculated
    Then the conclusion of the committee should be "<diesel_consumed>"
    Examples:
      | duration | distance_estimate | bus_class      | diesel_consumed |
      |       40 |                   | regional coach |         5.03461 |
      |          |     60            | city transit   |        25.40316 |
      |          |                   | regional coach |         5.03461 |
      |          |                   | city transit   |         3.04574 |
