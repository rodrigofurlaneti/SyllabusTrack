Feature: Educational Institution Management
  As an administrator
  I want to manage educational institutions in the system
  So that students can select their institutions when planning transfers

  # ── Create ─────────────────────────────────────────────────────────────────

  Scenario: Create institution with valid data
    Given I want to create an institution named "FAM Faculdade" with acronym "FAM" at location "São Paulo - SP"
    When I submit the create institution command
    Then the institution should be created successfully
    And the institution should be persisted in the repository

  Scenario: Create institution fails when name is empty
    Given I want to create an institution with empty name
    When I submit the create institution command
    Then the institution creation should fail with error code "Institution.EmptyName"
    And no institution should be persisted

  Scenario: Create institution with only name (acronym and location are optional)
    Given I want to create an institution named "Universidade X" with acronym "" at location ""
    When I submit the create institution command
    Then the institution should be created successfully

  # ── Update ─────────────────────────────────────────────────────────────────

  Scenario: Update existing institution successfully
    Given an existing institution with ID 1 named "FAM"
    When I update institution 1 with name "FAM Atualizada" acronym "FAM2" and location "SP"
    Then the institution update should succeed
    And the institution name should be "FAM Atualizada"

  Scenario: Update institution fails when institution does not exist
    Given no institution exists with ID 99
    When I update institution 99 with name "Qualquer" acronym "Q" and location "SP"
    Then the institution update should fail with error code "Institution.NotFound"

  Scenario: Update institution fails when new name is empty
    Given an existing institution with ID 1 named "FAM"
    When I update institution 1 with empty name
    Then the institution update should fail with error code "Institution.EmptyName"

  # ── GetById ────────────────────────────────────────────────────────────────

  Scenario: Get institution by ID when it exists
    Given an existing institution with ID 5 named "UNIP" active
    When I request institution by ID 5
    Then the get institution query should succeed
    And the response should contain institution named "UNIP"

  Scenario: Get institution by ID when it does not exist
    Given no institution exists with ID 999
    When I request institution by ID 999
    Then the get institution query should fail with error code "Institution.NotFound"

  # ── GetAll ─────────────────────────────────────────────────────────────────

  Scenario: Get all active institutions
    Given there are 3 active institutions in the repository
    When I request all active institutions
    Then the get all query should succeed
    And the response should contain 3 institutions
