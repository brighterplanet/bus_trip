Feature: Bus Trip Committee Calculations
  The bus trip model should generate correct committee calculations

  Background:
    Given a bus_trip

  Scenario: Date committee from timeframe
    Given a characteristic "timeframe" of "2009-06-06/2010-01-01"
    When the "date" committee reports
    Then the committee should have used quorum "from timeframe"
    And the conclusion of the committee should be "2009-06-06"

  Scenario: Passengers from default bus class
    Given the "passengers" committee reports
    Then the conclusion of the committee should be "7.485"
  
  Scenario: Passengers from bus class
    Given a characteristic "bus_class.name" of "city transit"
    When the "passengers" committee reports
    Then the conclusion of the committee should be "9.0"
  
  Scenario: Speed from default bus class
    Given the "speed" committee reports
    Then the conclusion of the committee should be "31.94387"
  
  Scenario: Speed from bus class
    Given a characteristic "bus_class.name" of "city transit"
    When the "speed" committee reports
    Then the conclusion of the committee should be "21.0"
  
  Scenario: Distance from default bus class
    Given the "distance" committee reports
    Then the committee should have used quorum "from bus class"
    And the conclusion of the committee should be "8.00262"
  
  Scenario: Distance from bus class
    Given a characteristic "bus_class.name" of "city transit"
    When the "distance" committee reports
    Then the committee should have used quorum "from bus class"
    And the conclusion of the committee should be "6.0"
  
  Scenario: Distance from duration and speed
    Given a characteristic "duration" of "1800"
    When the "bus_class" committee reports
    And the "speed" committee reports
    And the "distance" committee reports
    Then the committee should have used quorum "from duration and speed"
    And the conclusion of the committee should be "15.97193"

  Scenario Outline: HFC emission from default distance, default bus class, default passengers, date, and timeframe
    Given a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "bus_class" committee reports
    And the "passengers" committee reports
    And the "distance" committee reports
    And the "hfc_emission" committee reports
    Then the committee should have used quorum "from distance, bus class, passengers, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 0.03175  |
      | 2010-06-01 | 2010-01-01/2010-05-31 | 0.0      |

  Scenario: HFC emission from bus class
    Given a characteristic "bus_class.name" of "city transit"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "date" committee reports
    And the "passengers" committee reports
    And the "distance" committee reports
    And the "hfc_emission" committee reports
    Then the committee should have used quorum "from distance, bus class, passengers, date, and timeframe"
    And the conclusion of the committee should be "0.00667"

  Scenario Outline: N2O emission from default distance, default bus class, default passengers, date, and timeframe
    Given a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "bus_class" committee reports
    And the "passengers" committee reports
    And the "distance" committee reports
    And the "n2o_emission" committee reports
    Then the committee should have used quorum "from distance, bus class, passengers, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 0.00760  |
      | 2010-06-01 | 2010-01-01/2010-05-31 | 0.0      |

  Scenario: N2O emission from bus class
    Given a characteristic "bus_class.name" of "city transit"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "date" committee reports
    And the "passengers" committee reports
    And the "distance" committee reports
    And the "n2o_emission" committee reports
    Then the committee should have used quorum "from distance, bus class, passengers, date, and timeframe"
    And the conclusion of the committee should be "0.00587"

  Scenario Outline: CH4 emission from default distance, default bus class, default passengers, date, and timeframe
    Given a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "bus_class" committee reports
    And the "passengers" committee reports
    And the "distance" committee reports
    And the "ch4_emission" committee reports
    Then the committee should have used quorum "from distance, bus class, passengers, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 0.00641  |
      | 2010-06-01 | 2010-01-01/2010-05-31 | 0.0      |

  Scenario: CH4 emission from bus class
    Given a characteristic "bus_class.name" of "city transit"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "date" committee reports
    And the "passengers" committee reports
    And the "distance" committee reports
    And the "ch4_emission" committee reports
    Then the committee should have used quorum "from distance, bus class, passengers, date, and timeframe"
    And the conclusion of the committee should be "0.00506"

  Scenario Outline: CO2 biogenic emission from default distance, default bus class, default passengers, date, and timeframe
    Given a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "bus_class" committee reports
    And the "passengers" committee reports
    And the "distance" committee reports
    And the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from distance, bus class, passengers, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 0.06148  |
      | 2010-06-01 | 2010-01-01/2010-05-31 | 0.0      |

  Scenario: CO2 biogenic emission from bus class
    Given a characteristic "bus_class.name" of "city transit"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "date" committee reports
    And the "passengers" committee reports
    And the "distance" committee reports
    And the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from distance, bus class, passengers, date, and timeframe"
    And the conclusion of the committee should be "0.06859"

  Scenario Outline: CO2 emission from default distance, default bus class, default passengers, date, and timeframe
    Given a characteristic "date" of "<date>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "bus_class" committee reports
    And the "passengers" committee reports
    And the "distance" committee reports
    And the "co2_emission" committee reports
    Then the committee should have used quorum "from distance, bus class, passengers, date, and timeframe"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | date       | timeframe             | emission |
      | 2010-06-01 | 2010-01-01/2011-01-01 | 1.10407  |
      | 2010-06-01 | 2010-01-01/2010-05-31 | 0.0      |

  Scenario: CO2 emission from bus class
    Given a characteristic "bus_class.name" of "city transit"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "date" committee reports
    And the "passengers" committee reports
    And the "distance" committee reports
    And the "co2_emission" committee reports
    Then the committee should have used quorum "from distance, bus class, passengers, date, and timeframe"
    And the conclusion of the committee should be "0.93204"
