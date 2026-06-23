Feature: Multiple Targets Planning (N→N)
  As a student who completed one or more degree programs
  I want to simultaneously plan transfers to multiple target programs
  So that I can compare which target program offers the best credit transfer

  Scenario: Get plan with one source and one target
    Given source program IDs [1] and target program IDs [2]
    And the multiple targets repository returns a valid response
    When I request the multiple targets plan
    Then the multiple targets query should succeed
    And the response should contain target results

  Scenario: Get plan with multiple sources and multiple targets
    Given source program IDs [1, 2] and target program IDs [3, 4, 5]
    And the multiple targets repository returns a valid response
    When I request the multiple targets plan
    Then the multiple targets query should succeed

  Scenario: Get plan fails when source list is null
    Given source program IDs are null and target program IDs [2]
    When I request the multiple targets plan
    Then the multiple targets query should fail with error code "MultipleTargetsPlanning.NoSource"

  Scenario: Get plan fails when source list is empty
    Given source program IDs [] and target program IDs [2]
    When I request the multiple targets plan
    Then the multiple targets query should fail with error code "MultipleTargetsPlanning.NoSource"

  Scenario: Get plan fails when target list is null
    Given source program IDs [1] and target program IDs are null
    When I request the multiple targets plan
    Then the multiple targets query should fail with error code "MultipleTargetsPlanning.NoTarget"

  Scenario: Get plan fails when target list is empty
    Given source program IDs [1] and target program IDs []
    When I request the multiple targets plan
    Then the multiple targets query should fail with error code "MultipleTargetsPlanning.NoTarget"

  Scenario: Get plan fails when source contains negative ID
    Given source program IDs [-1] and target program IDs [2]
    When I request the multiple targets plan
    Then the multiple targets query should fail with error code "MultipleTargetsPlanning.InvalidIds"

  Scenario: Get plan fails when target contains zero ID
    Given source program IDs [1] and target program IDs [0]
    When I request the multiple targets plan
    Then the multiple targets query should fail with error code "MultipleTargetsPlanning.InvalidIds"

  Scenario: Get plan fails when source and target share a program ID
    Given source program IDs [1, 2] and target program IDs [2, 3]
    When I request the multiple targets plan
    Then the multiple targets query should fail with error code "MultipleTargetsPlanning.Overlap"

  Scenario: Get plan fails when courses are not found in the repository
    Given source program IDs [1] and target program IDs [99]
    And the multiple targets repository returns null (courses not found)
    When I request the multiple targets plan
    Then the multiple targets query should fail with error code "MultipleTargetsPlanning.NotFound"
