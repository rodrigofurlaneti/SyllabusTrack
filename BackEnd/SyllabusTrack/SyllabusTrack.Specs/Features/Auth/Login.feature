Feature: Student Login
  As a registered student
  I want to log in to SyllabusTrack
  So that I can access my academic planning

  Scenario: Successful login with email
    Given a registered student with email "rodrigo@gmail.com" and password "senha123"
    When I log in with identifier "rodrigo@gmail.com" and password "senha123"
    Then the login should succeed
    And I should receive a JWT token

  Scenario: Successful login with username
    Given a registered student with username "rodrigof" and password "senha123"
    When I log in with identifier "rodrigof" and password "senha123"
    Then the login should succeed
    And I should receive a JWT token

  Scenario: Login fails when student does not exist
    Given no student exists with identifier "unknown@gmail.com"
    When I log in with identifier "unknown@gmail.com" and password "any_password"
    Then the login should fail with error code "Auth.InvalidCredentials"

  Scenario: Login fails when password is wrong
    Given a registered student with email "rodrigo@gmail.com" and password "senha123"
    When I log in with identifier "rodrigo@gmail.com" and password "wrong_password"
    Then the login should fail with error code "Auth.InvalidCredentials"

  Scenario: Login failure should not expose which field is wrong
    Given no student exists with identifier "hacker@gmail.com"
    When I log in with identifier "hacker@gmail.com" and password "guess"
    Then the login should fail with error code "Auth.InvalidCredentials"
    And no JWT token should be generated
