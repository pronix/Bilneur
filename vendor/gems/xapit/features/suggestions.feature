Feature: Suggestions

  Scenario: Spelling suggestion
    Given an empty database at "tmp/spellingdb"
    And spelling is enabled
    And indexed records named "Zebra, Apple, Bike"
    When I query for "zerba bike aple"
    Then I should have "zebra bike apple" as a spelling suggestion

  Scenario: No spelling suggestion
    Given indexed records named "Zebra, Apple, Bike"
    When I query for "zerba bike aple"
    Then I should have "" as a spelling suggestion

  Scenario: Find similar records
    Given indexed records named "Jason John Smith, John Doe, Jason Smith, Jacob Johnson"
    When I query for similar records for "Jason John Smith"
    Then I should find records named "Jason Smith, John Doe"

  Scenario: Match similar words with stemming
    Given indexed records named "flies, fly, glider"
    When I query for "flying"
    Then I should find records named "flies, fly"
