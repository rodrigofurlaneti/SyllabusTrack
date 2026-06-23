Feature: Academic Planning
  As a student who completed a degree program
  I want to receive a semester-by-semester academic plan for a target program
  So that I can understand exactly which subjects I still need to take

  Scenario: Get academic plan for valid source and target programs
    Given a source program with ID 1 and a target program with ID 2
    And the repository returns a valid academic plan
    When I request the academic plan
    Then the academic plan query should succeed
    And the plan should contain semester details

  Scenario: Get academic plan when target program has no matching subjects
    Given a source program with ID 1 and a target program with ID 3
    And the repository returns a plan with 0 matched subjects
    When I request the academic plan
    Then the academic plan query should succeed
    And the match percentage should be 0

  Scenario: Get academic plan when repository returns null (course not found)
    Given a source program with ID 1 and a target program with ID 999
    And the repository returns null for the academic plan
    When I request the academic plan
    Then the academic plan query should fail with error code "Planning.NotFound"

  Scenario: Get academic plan when source program covers all target subjects
    Given a source program with ID 1 and a target program with ID 2
    And the repository returns a plan with 100% match
    When I request the academic plan
    Then the academic plan query should succeed
    And the match percentage should be 100
    And the years saved should be greater than 0
