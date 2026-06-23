Feature: Student Registration
  As a prospective student
  I want to register an account in SyllabusTrack
  So that I can track and plan my academic journey

  Background:
    Given the email "rodrigo@gmail.com" is available
    And the username "rodrigof" is available

  Scenario: Successful registration with valid data
    Given I want to register with the following data:
      | Field       | Value            |
      | FullName    | Rodrigo Furlaneti|
      | Username    | rodrigof         |
      | Email       | rodrigo@gmail.com|
      | PhoneNumber | 11999990000      |
      | Password    | senha123         |
    When I submit the registration
    Then the registration should succeed
    And the new student account should be persisted

  Scenario: Registration fails when email is already in use
    Given the email "rodrigo@gmail.com" is already taken
    When I submit the registration with email "rodrigo@gmail.com" and username "rodrigof2"
    Then the registration should fail with error code "Auth.EmailTaken"

  Scenario: Registration fails when username is already in use
    Given the username "rodrigof" is already taken
    When I submit the registration with email "outro@gmail.com" and username "rodrigof"
    Then the registration should fail with error code "Auth.UsernameTaken"

  Scenario Outline: Registration fails when email format is invalid
    When I submit the registration with email "<InvalidEmail>" and username "rodrigof"
    Then the registration should fail with error code "Email.Invalid"
    Examples:
      | InvalidEmail      |
      | not-an-email      |
      | missingatdomain   |
      | @nodomain.com     |

  Scenario: Registration fails when full name is empty
    Given the email "x@gmail.com" is available
    And the username "xuser" is available
    When I submit a registration with empty full name
    Then the registration should fail with error code "Student.EmptyName"

  Scenario: Registration fails when username is empty
    Given the email "x@gmail.com" is available
    And the username is empty
    When I submit a registration with empty username
    Then the registration should fail with error code "Student.EmptyUsername"
