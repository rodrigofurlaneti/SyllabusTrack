Feature: Multiple Source Planning (N→1)
  As a student who completed multiple degree programs
  I want to plan a transfer using the union of subjects from all completed programs
  So that I avoid retaking subjects I've already studied in any of my programs

  Scenario: Get plan with single source and valid target
    Given source programs with IDs [1] and target program with ID 2
    And the multiple planning repository returns a valid plan
    When I request the multiple source plan
    Then the multiple plan query should succeed

  Scenario: Get plan with multiple source programs
    Given source programs with IDs [1, 2] and target program with ID 3
    And the multiple planning repository returns a valid plan
    When I request the multiple source plan
    Then the multiple plan query should succeed

  Scenario: Get plan fails when source program list is empty
    Given source programs with IDs [] and target program with ID 2
    When I request the multiple source plan
    Then the multiple plan query should fail with error code "MultiplePlanning.NoSource"

  Scenario: Get plan fails when source list contains a zero ID
    Given source programs with IDs [0] and target program with ID 2
    When I request the multiple source plan
    Then the multiple plan query should fail with error code "MultiplePlanning.InvalidIds"

  Scenario: Get plan fails when source list contains a negative ID
    Given source programs with IDs [-1] and target program with ID 2
    When I request the multiple source plan
    Then the multiple plan query should fail with error code "MultiplePlanning.InvalidIds"

  Scenario: Get plan fails when target ID is zero
    Given source programs with IDs [1] and target program with ID 0
    When I request the multiple source plan
    Then the multiple plan query should fail with error code "MultiplePlanning.InvalidIds"

  Scenario: Get plan fails when target program is also in the source list
    Given source programs with IDs [1, 2] and target program with ID 1
    When I request the multiple source plan
    Then the multiple plan query should fail with error code "MultiplePlanning.SameProgram"

  Scenario: Get plan fails when courses are not found in the repository
    Given source programs with IDs [1] and target program with ID 99
    And the multiple planning repository returns null (courses not found)
    When I request the multiple source plan
    Then the multiple plan query should fail with error code "MultiplePlanning.NotFound"
