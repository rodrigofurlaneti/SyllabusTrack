Feature: Program Recommendations
  As a student enrolled in one or more programs
  I want to receive ranked recommendations of other programs
  So that I can identify the best transfer options based on my completed subjects

  Scenario: Get recommendations for a student with matching programs
    Given a student with ID 5 has completed subjects that match other programs
    And the recommendation repository returns 3 recommendations for student 5
    When I request recommendations for student 5
    Then the recommendations query should succeed
    And the response should contain 3 recommendations

  Scenario: Get recommendations when no programs match
    Given a student with ID 10 has no matching programs
    And the recommendation repository returns an empty list for student 10
    When I request recommendations for student 10
    Then the recommendations query should succeed
    And the response should be empty

  Scenario: Get recommendations always succeeds (even for a student not yet enrolled)
    Given the recommendation repository returns an empty list for student 1
    When I request recommendations for student 1
    Then the recommendations query should succeed

  Scenario: Get recommendations passes the correct student ID to the repository
    Given the recommendation repository returns an empty list for student 42
    When I request recommendations for student 42
    Then the repository should have been called with student ID 42
