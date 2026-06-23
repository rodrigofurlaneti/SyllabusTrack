Feature: Course Comparison
  As a student
  I want to compare two degree programs
  So that I can see how many subjects from my completed program apply to the target program

  Scenario: Compare two valid programs
    Given a source program with ID 1 named "ADS" and a target program with ID 2 named "SI"
    And the comparison repository returns a valid result with 50% match
    When I request the course comparison
    Then the comparison should succeed
    And the match percentage should be 50

  Scenario: Compare programs when source program has high overlap with target
    Given a source program with ID 1 named "ADS" and a target program with ID 3 named "Banco de Dados"
    And the comparison repository returns a result with 80% match
    When I request the course comparison
    Then the comparison should succeed
    And the match percentage should be 80

  Scenario: Compare programs when source program has no overlap with target
    Given a source program with ID 1 named "ADS" and a target program with ID 4 named "Medicina"
    And the comparison repository returns a result with 0% match
    When I request the course comparison
    Then the comparison should succeed
    And the match percentage should be 0

  Scenario: Compare programs when one or both programs do not exist
    Given a source program with ID 1 and a target program with ID 999
    And the comparison repository returns null (programs not found)
    When I request the course comparison
    Then the comparison should fail with error code "Comparison.NotFound"
